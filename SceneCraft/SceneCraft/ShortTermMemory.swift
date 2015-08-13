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
    var memory:[String:AbstractShape]
    
    init()
    {
        memory = [String:AbstractShape]()
        
        let floor = AbstractShape()
        floor.isSurface(AbstractAxis.SIDE_A)
        floor.top = AbstractPointer(axis:AbstractAxis.SIDE_A, direction:AbstractDirection.AXIS_POSITIVE)
        
        memory["floor"] = floor
        
        let wall = AbstractShape()
        wall.isSurface(AbstractAxis.SIDE_B)
        wall.top = AbstractPointer(axis:AbstractAxis.SIDE_A, direction:AbstractDirection.AXIS_POSITIVE)
        wall.fill = AbstractFill.FILL_COMPLETE
        
        // Watch what happens when you tell ATLAS that walls must be SQUARE. It'll TRY to do it!
        
        memory["wall"] = wall
    }
        
//    init()
//    {
//        memory = [String:ShapeConcept]()
//        
//        // HARD-CODE, POPULATE WITH SHAPE CONCEPTS
//        
//        let cubeConcept = ShapeConcept()
//        let cubeShape = AbstractShape(sideA:AbstractProportion.PROP_EQUAL, sideB:AbstractProportion.PROP_EQUAL, sideC:AbstractProportion.PROP_EQUAL)
//        cubeConcept.addShape(cubeShape)
//        
//        memory["cube"] = cubeConcept
//        
//        let chairConcept = ShapeConcept()
//        let chairShape = AbstractShape(sideA:AbstractProportion.PROP_EQUAL, sideB:AbstractProportion.PROP_EQUAL, sideC:AbstractProportion.PROP_GREATER)
//        chairShape.top = AbstractPointer(axis:AbstractAxis.SIDE_C, direction:AbstractDirection.AXIS_POSITIVE)
//        chairConcept.addShape(chairShape)
//        
//        let seatShape = AbstractShape(sideA:AbstractProportion.PROP_GREATER, sideB:AbstractProportion.PROP_GREATER, sideC:AbstractProportion.PROP_EQUAL)
//        seatShape.top = AbstractPointer(axis:AbstractAxis.SIDE_C, direction:AbstractDirection.AXIS_POSITIVE)
//        
//        memory["chair"] = chairConcept
//    }
    
    
}