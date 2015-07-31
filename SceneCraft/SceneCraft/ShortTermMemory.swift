//
//  ShortTermMemory.swift
//  SceneCraft
//
//  Created by Alicia Cicon on 7/30/15.
//  Copyright © 2015 Runemark. All rights reserved.
//

import Foundation

class ShortTermMemory
{
    var memory:[String:ShapeConcept]
        
    init()
    {
        memory = [String:ShapeConcept]()
        
        // HARD-CODE, POPULATE WITH SHAPE CONCEPTS
        
        var cubeConcept = ShapeConcept()
        
        memory["cube"] = cubeConcept
    }
}