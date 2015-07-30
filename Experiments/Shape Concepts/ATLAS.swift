//
//  ATLAS.swift
//  ATLAS
//
//  Created by Martin Mumford on 4/20/15.
//  Copyright (c) 2015 Brigham Young University. All rights reserved.
//

import Foundation

public protocol RequestDelegate {
    
    func requestUnknown(request:String)
}

class ATLAS {
    // communicates with the human
    var requestDelegate:RequestDelegate?
    
    var declarativeMemory:[String:Concept]
    var proceduralMemory:[String:Technique]
    
    init()
    {
        ///////////////////////////////////////////////////////
        // Declarative Memory
        ///////////////////////////////////////////////////////
        declarativeMemory = [String:Concept]()
        
        let pointConcept = Concept(identifier:"point")
        let pointShape = Point()
        pointConcept.shape = pointShape
        declarativeMemory["point"] = pointConcept
        
//        let lineConcept = Concept(identifier:"line")
//        let lineShape = AbstractShape(name:"line", type:.flow)
//
//        let pointShapeComponent = declarativeMemory["point"]!.shape!
//        let pointA_index = lineShape.addComponent(pointShapeComponent)
//        let pointB_index = lineShape.addComponent(pointShapeComponent)
//
//        lineConcept.shape = lineShape
//        declarativeMemory["line"] = lineConcept
        
        // Lines SHOULD be the <origin><direction><terminus> version (just reversable).
        
        ///////////////////////////////////////////////////////
        // Procedural Memory
        ///////////////////////////////////////////////////////
        
        proceduralMemory = [String:Technique]()
        
//        let pointTechnique = Technique("point")
//        proceduralMemory["point"] = pointTechnique
        
        // Technique - apply an abstractShape to the canvas.
        // This will be unique to the domain.
        
        // How to apply a POINT to the canvas?
        // Well, we need some ATOMIC ACTIONS specific to this domain.
        
        // ATOMIC TECHNIQUE - (CHANGE PIXEL COLOR)
        // ATOMIC TECHNIQUE - FILL PIXEL
    }
    
    func setDelegate(delegate:RequestDelegate)
    {
        requestDelegate = delegate
    }
    
    // This is the creative process!
    func represent(request:String) -> Drawing
    {
        let drawing = Drawing(width:15, height:15)
        
        // First, recall to mind the concept being requested
        if let matchingConcept = declarativeMemory[request]
        {
            let shape = matchingConcept.shape!
            
            // Scan through the shape components one by one and place them according to constraints (not the best way to do this)
            for componentShape in shape.components.items
            {
                // Just DRAW the things (randomly place each)
                // Look for a technique for drawing a point
                let pointTechnique = proceduralMemory["point"]!
//                pointTechnique.applyToDrawing(drawing, coord:randomPosition)
            }
            
        }
        else
        {
            // ATLAS doesn't know what that is...
            requestDelegate!.requestUnknown(request)
        }
        
        return drawing
    }
}