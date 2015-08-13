//
//  WIP.swift
//  SceneCraft
//
//  Created by Alicia Cicon on 8/6/15.
//  Copyright © 2015 Runemark. All rights reserved.
//

import Foundation

struct Step
{
    var coord:DiscreteCoord
    var tile:Int
}

// Work in Progress (WIP)
class WIP
{
    var steps:[Step]
    var regions:RegionMap
    var bounds:DiscreteCoord
    
    // Provide a maximum space within which to work
    init(x:Int, y:Int, z:Int)
    {
        steps = [Step]()
        bounds = DiscreteCoord(x:x, y:y, z:z)
        regions = RegionMap(x:bounds.x, y:bounds.y, z:bounds.z)
    }
    
    func addStep(coord:DiscreteCoord, tile:Int)
    {
        let step = Step(coord:coord, tile:tile)
        steps.append(step)
    }
    
    func eraseMap()
    {
        var coordsToErase = Set<DiscreteCoord>()
        
        for step in steps
        {
            if (step.tile > 0)
            {
                coordsToErase.insert(step.coord)
            }
        }
    }
    
    // PLAN A: ALL HARD-CODED
    
    // Goal: Represent a FLOOR
}