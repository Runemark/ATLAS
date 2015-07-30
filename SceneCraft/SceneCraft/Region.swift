//
//  Region.swift
//  SceneCraft
//
//  Created by Martin Mumford on 7/8/15.
//  Copyright (c) 2015 Brigham Young University. All rights reserved.
//

import Foundation

class Region
{
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Variables
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // The points comprising this region
    var coordinates:Set<DiscreteCoord>
    // The volume enclosing those points
    var volume:Volume
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Initialization
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    convenience init()
    {
        self.init(volume:Volume(x:0, y:0, z:0, xLen:0, yLen:0, zLen:0), coords:nil)
    }
    
    convenience init(coords:Set<DiscreteCoord>)
    {
        // Automatically compute the volume
        var volume = Volume(x:0, y:0, z:0, xLen:0, yLen:0, zLen:0)
        
        var firstCoord = true
        for coord in coords
        {
            if (firstCoord)
            {
                volume.moveToOrigin(coord)
                volume.xLen = 1
                volume.yLen = 1
                volume.zLen = 1
                
                firstCoord = false
            }
            else
            {
                volume.expandToIncludeCoord(coord)
            }
        }
        
        self.init(volume:volume, coords:coords)
    }
    
    init(volume:Volume, coords:Set<DiscreteCoord>?)
    {
        self.volume = volume
        self.coordinates = Set<DiscreteCoord>()
        
        if (coords != nil && coords!.count > 0)
        {
            for coord in coords!
            {
                addCoord(coord)
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Structure
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func addCoord(coord:DiscreteCoord)
    {
        if (coordinates.count == 0)
        {
            volume.moveToOrigin(coord)
            volume.xLen = 1
            volume.yLen = 1
            volume.zLen = 1
        }
        else
        {
            volume.expandToIncludeCoord(coord)
        }
        
        coordinates.insert(coord)
    }
}