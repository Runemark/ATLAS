//
//  Technique.swift
//  ATLAS
//
//  Created by Martin Mumford on 4/20/15.
//  Copyright (c) 2015 Brigham Young University. All rights reserved.
//

import Foundation

class Technique {
    // A technique is a means of altering the drawing in some way
    // A technique can be composed of sub-techniques
    
    // Right now, in its simplest form, a technique is literally just placing a pixel
    // Not even a combination of pixels. Just A PIXEL.
    
    // MISSING FEATURES:
    // Reference Points/Guidelines
    // For example, in a CIRCLE, it is important to know where the center is.
    
    // DESIGN PROBLEM:
    // Different Techniques will require different (and often optional) paramters
    // 1 technique (point): Load them into the function parameters
    // 2 techniques (point, line): Load them generically into function parameters
    
    // Point requires only a coordinate
    
    // Point drawing technique
    
    // I need a TECHNIQUE to convert a concept abstract shape to a reality.
    
    var name:String
    
    init(name:String)
    {
        self.name = name
    }
    
    // a technique is essentially a function being defined on-the-fly. It is:
    // A: composed of a series of other techniques + atomic techniques
    // B: composed of
    
    // We need to specify WHAT the technique does (end-result)
    
    // Q: Is there a 1:1 mapping between abstractShapes and techniques?
    //     Or is the abstractShape the GOAL, and the techniques the method of sort of fleshing that out?
    
    // Q: Is there a 1:1 mapping between basic AbstractShapes and techniques?
    
    // Technique for POINT
    // Technique for MULTIPOINT
    // Technique for TRIPOINT
    // Technique for LINE
    // Technique for HORIZONTAL LINE
    // Technique for VERTICAL LINE
    // Technique for SQUARE
    // Technique for RECTANGLE
    // Technique for TRIANGLE
    
    
}