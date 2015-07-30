//
//  RegionMap.swift
//  SceneCraft
//
//  Created by Martin Mumford on 7/7/15.
//  Copyright (c) 2015 Brigham Young University. All rights reserved.
//

import Foundation

class RegionMap
{
    // Represents a STRICT hierarchy of regions. No point
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Class Variables
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var root:RegionNode
    var uniqueRegionLabels:Set<Int>
    var regionLabels:Array3D<Int>
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Initialization
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    init(x:Int, y:Int, z:Int)
    {
        // The root will always have a label of 0, and a volume the size of the entire map
        root = RegionNode(label:0)
        
        uniqueRegionLabels = Set<Int>()
        uniqueRegionLabels.insert(0)
        
        regionLabels = Array3D<Int>(x:x, y:y, z:z, filler:0)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Indexing
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Creates (BUT DOES NOT ADD) a new, unused region index
    func createNewRegionLabel() -> Int
    {
        var newRegionLabel = 0
        
        while (uniqueRegionLabels.contains(newRegionLabel))
        {
            newRegionLabel++
        }
        
        return newRegionLabel
    }
    
    // Creates and ADDS a new, unused region index
    func addNewRegionLabel() -> Int
    {
        let newRegionLabel = createNewRegionLabel()
        uniqueRegionLabels.insert(newRegionLabel)
        
        return newRegionLabel
    }
    
    // Checks whether the region map contains a particular label
    func containsRegionLabel(label:Int) -> Bool
    {
        return uniqueRegionLabels.contains(label)
    }
    
    // Counts the number of times a label occurs in the region map
    func occurancesOfRegionLabel(label:Int) -> Int
    {
        var occurances = 0
        
        for x in 0..<regionLabels.xMax
        {
            for y in 0..<regionLabels.yMax
            {
                for z in 0..<regionLabels.zMax
                {
                    if (regionLabels[x,y,z] == label)
                    {
                        occurances++
                    }
                }
            }
        }
        
        return occurances
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Labeling
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func labelAtLocation(loc:DiscreteCoord, label:Int)
    {
        if (!containsRegionLabel(label))
        {
            uniqueRegionLabels.insert(label)
        }
        
        regionLabels[loc] = label
    }
    
    func labelAtLocations(locs:[DiscreteCoord], label:Int)
    {
        if (!containsRegionLabel(label))
        {
            uniqueRegionLabels.insert(label)
        }
        
        for loc in locs
        {
            regionLabels[loc] = label
        }
    }
    
    func labelAtLocations(locs:Set<DiscreteCoord>, label:Int)
    {
        if (!containsRegionLabel(label))
        {
            uniqueRegionLabels.insert(label)
        }
        
        for loc in locs
        {
            regionLabels[loc] = label
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}