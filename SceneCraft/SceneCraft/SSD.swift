//
//  TileMapDecomposition.swift
//  SceneCraft
//
//  Created by Martin Mumford on 7/6/15.
//  Copyright (c) 2015 Brigham Young University. All rights reserved.
//

import Foundation

//////////////////////////////////////////////////////////////////////////////////////////
// Semantic Subvolume Decomposition (SSD)
//////////////////////////////////////////////////////////////////////////////////////////

extension TileMap
{
    func isolateRegions() -> (tags:Array3D<Int>, uniqueTags:Set<Int>)
    {
        let regionTags = Array3D<Int>(x:grid.xMax, y:grid.yMax, z:grid.zMax, filler:0)
        var uniqueTags = Set<Int>()
        uniqueTags.insert(0)
        
        var unvisitedSet = Set<DiscreteCoord>()
        var visitedSet = Set<DiscreteCoord>()
        
        // Load all of the coordinates of the grid into the unvisited set
        for x in 0..<grid.xMax
        {
            for y in 0..<grid.yMax
            {
                for z in 0..<grid.zMax
                {
                    unvisitedSet.insert(DiscreteCoord(x:x, y:y, z:z))
                }
            }
        }
        
        var currentSegmentId = 0
        
        // Until we have visited every single coordinate in the grid
        while (unvisitedSet.count > 0)
        {
            // Pick an unvisited coordinate at random
            let seed = unvisitedSet.first!
            
            if (grid[seed] > 0)
            {
                currentSegmentId++
                uniqueTags.insert(currentSegmentId)
                
                // We have a SEED to explore
                var unvisitedNeighbors = Set<DiscreteCoord>()
                unvisitedNeighbors.insert(seed)
                
                while (unvisitedNeighbors.count > 0)
                {
                    let nextNeighbor = unvisitedNeighbors.first!
                    
                    if (grid[nextNeighbor] > 0)
                    {
                        regionTags[nextNeighbor] = currentSegmentId
                        
                        // CONSIDER ADJACENT AND DIAGONAL TILES AS 'NEIGHBORS' (increases computation time by 25%)
                        //                        unvisitedNeighbors.unionInPlace(grid.neighborhood(nextNeighbor).subtract(visitedSet))
                        
                        // ONLY CONSIDER ADJACENT TILES AS 'NEIGHBORS' (cuts computation time by 25%)
                        unvisitedNeighbors.unionInPlace(grid.immediateNeighborhood(nextNeighbor).subtract(visitedSet))
                    }
                    
                    unvisitedNeighbors.remove(nextNeighbor)
                    unvisitedSet.remove(nextNeighbor)
                    visitedSet.insert(nextNeighbor)
                }
            }
            else
            {
                // Visit it
                unvisitedSet.remove(seed)
                visitedSet.insert(seed)
            }
        }
        
        return (tags:regionTags, uniqueTags:uniqueTags)
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Horribly Inefficient Subvolume Decomposition
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func decomposeVolume() -> RegionMap
    {
        let regions = RegionMap(x:grid.xMax, y:grid.yMax, z:grid.zMax)
        
        // First, isolate the volume into distinct regions
        let (tags, uniqueTags) = isolateRegions()
        
        // Create the region children
        for tag in uniqueTags
        {
            if (tag > 0)
            {
                // Create a new child and add it to the root
                let isolatedChild = RegionNode(label:tag)
                regions.root.addChild(isolatedChild)
                
                regions.uniqueRegionLabels.insert(tag)
            }
        }
        
        for x in 0..<tags.xMax
        {
            for y in 0..<tags.yMax
            {
                for z in 0..<tags.zMax
                {
                    let volumeCoord = DiscreteCoord(x:x, y:y, z:z)
                    // Add it to the region map
                    let isolatedRegionTag = tags[volumeCoord]
                    
                    if (isolatedRegionTag > 0)
                    {
                        // Add the coordinate to the region node
                        regions.root.descendantWithLabel(isolatedRegionTag)!.addCoord(volumeCoord)
                        // Also add all non-air coordinates directly to the root as well
                        regions.root.addCoord(volumeCoord)
                        
                        // Label the coordinate in the region map
                        regions.labelAtLocation(volumeCoord, label:isolatedRegionTag)
                    }
                }
            }
        }
        
        for child in regions.root.children
        {
            // Scan the isolated regions and decompose them into hierarchical region structures
            decomposeRegionNode(child, regions:regions)
        }
        
        return regions
    }
    
    func decomposeRegionNode(parent:RegionNode, regions:RegionMap)
    {
        // Until there are no more parent labels left in the region map...
        var stillSearching = true
        while (stillSearching)
        {
            let parentVolume = parent.region.volume
            // Find the best possible subvolume within the parent's volume
            let bestSubvolume = bestSubvolumeInVolume(parentVolume, label:parent.label, regions:regions)
            
            if (bestSubvolume == parentVolume)
            {
                // This volume is as small as we can meaningfully break it down (it's best subvolume is itself)
                return
            }
            else
            {
                // This subvolume is meaningfully broken down, we need to create a new index for it and continue
                
                // STEP 1: Create and add a new region label
                let newLabel = regions.addNewRegionLabel()
                // STEP 2: Create a new regionNode
                
                let subRegion = RegionNode(label:newLabel)
                
                for x in bestSubvolume.x..<bestSubvolume.x+bestSubvolume.xLen
                {
                    for y in bestSubvolume.y..<bestSubvolume.y+bestSubvolume.yLen
                    {
                        for z in bestSubvolume.z..<bestSubvolume.z+bestSubvolume.zLen
                        {
                            let subvolumeCoord = DiscreteCoord(x:x, y:y, z:z)
                            if (regions.regionLabels[subvolumeCoord] == parent.label)
                            {
                                // Add the point to the child region
                                subRegion.addCoord(subvolumeCoord)
                                
                                // Label it with the new label
                                regions.labelAtLocation(subvolumeCoord, label:newLabel)
                            }
                        }
                    }
                }
                
                // STEP 3: Add the new regionNode to the parent
                parent.addChild(subRegion)
                
                // STEP 4: Recurse on the child node
                decomposeRegionNode(subRegion, regions:regions)
            }
            
            stillSearching = (regions.occurancesOfRegionLabel(parent.label) > 0)
        }
    }
    
    // Find the best possible subvolume dealing with the specified index
    func bestSubvolumeInVolume(parent:Volume, label:Int, regions:RegionMap) -> Volume
    {
        var possibleSubvolumeSizes = possibleVolumeSizes(parent.size())
        
        // Sort by volume
        possibleSubvolumeSizes.sortInPlace({ $0.vol > $1.vol })
        
        var bestVolumeScore = 0.0
        var bestVolume = Volume(x:0, y:0, z:0, xLen:0, yLen:0, zLen:0)
        
        var volumeSizesChecked = 0
        
        for possibleSubvolumeSize in possibleSubvolumeSizes
        {
            // If it is POSSIBLE to beat the current score, then it's worth investigating. Otherwise, we're done.
            if (maximumScore(parent.size(), candidateSize:possibleSubvolumeSize) > bestVolumeScore)
            {
                volumeSizesChecked++
                
                // Generate all possible volumes using this subvolume size
                let subvolumes = possibleVolumesForVolumeSize(parent, unit:possibleSubvolumeSize)
                
                for subvolume in subvolumes
                {
                    let score = evaluateVolume(parent, candidate:subvolume, label:label, regions:regions)
                    if (score > bestVolumeScore)
                    {
                        bestVolumeScore = score
                        bestVolume = subvolume
                    }
                }
            }
            else
            {
                break
            }
        }
        
        //        println("checked \(volumeSizesChecked) volume sizes")
        
        return bestVolume
    }
    
    func maximumScore(parent:VolumeSize, candidateSize:VolumeSize) -> Double
    {
        let proportion = Double(candidateSize.vol) / Double(parent.vol)
        return evaluateVolumeMetrics(proportion, fullness:1.0)
    }
    
    // Returns a value between [0, 1] representing the quality of the candidate subvolume
    func evaluateVolume(parent:Volume, candidate:Volume, label:Int, regions:RegionMap) -> Double
    {
        let proportion = Double(candidate.vol) / Double(parent.vol)
        var tileCount = 0
        
        for x in candidate.x..<candidate.x+candidate.xLen
        {
            for y in candidate.y..<candidate.y+candidate.yLen
            {
                for z in candidate.z..<candidate.z+candidate.zLen
                {
                    if (regions.regionLabels[x,y,z] == label)
                    {
                        tileCount++
                    }
                }
            }
        }
        
        let fullness = Double(tileCount) / Double(candidate.vol)
        
        return evaluateVolumeMetrics(proportion, fullness:fullness)
    }
    
    func evaluateVolumeMetrics(proportion:Double, fullness:Double) -> Double
    {
        return (0.3)*proportion + (0.7)*fullness
    }
    
    func possibleVolumesForVolumeSize(parent:Volume, unit:VolumeSize) -> [Volume]
    {
        
        var volumes = [Volume]()
        
        let xIterations = parent.xLen - unit.x + 1
        let yIterations = parent.yLen - unit.y + 1
        let zIterations = parent.zLen - unit.z + 1
        
        for xStart in parent.x..<parent.x+xIterations
        {
            for yStart in parent.y..<parent.y+yIterations
            {
                for zStart in parent.z..<parent.z+zIterations
                {
                    // create a new volume starting at xStart, yStart, and zStart, and with the unit's shape
                    let volume = Volume(x:xStart, y:yStart, z:zStart, xLen:unit.x, yLen:unit.y, zLen:unit.z)
                    volumes.append(volume)
                }
            }
        }
        
        return volumes
    }
    
    func possibleVolumeSizes(parent:VolumeSize) -> [VolumeSize]
    {
        return possibleVolumeSizes(parent, lockedIndex:0)
    }
    
    func possibleVolumeSizes(parent:VolumeSize, lockedIndex:Int) -> [VolumeSize]
    {
        var volumeSizes = [VolumeSize]()
        
        if (lockedIndex < 3)
        {
            let maxLockedLength = parent[lockedIndex]
            for length in (1...maxLockedLength).reverse()
            {
                var nextVolumeSize = VolumeSize(x:parent.x, y:parent.y, z:parent.z)
                nextVolumeSize[lockedIndex] = length
                
                let newVolumeSizes = possibleVolumeSizes(nextVolumeSize, lockedIndex:lockedIndex+1)
                
                if (newVolumeSizes.count > 0)
                {
                    for newVolumeSize in newVolumeSizes
                    {
                        volumeSizes.append(newVolumeSize)
                    }
                }
                else
                {
                    volumeSizes.append(nextVolumeSize)
                }
            }
        }
        
        return volumeSizes
    }
}