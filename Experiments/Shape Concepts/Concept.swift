//
//  Concept.swift
//  ATLAS
//
//  Created by Martin Mumford on 4/20/15.
//  Copyright (c) 2015 Brigham Young University. All rights reserved.
//

import Foundation

class Concept {
    // Right now, a concept can only be a point. That's it.
    var identifier:String
    var shape:AbstractShape?
    
    init(identifier:String)
    {
        self.identifier = identifier
    }
}
