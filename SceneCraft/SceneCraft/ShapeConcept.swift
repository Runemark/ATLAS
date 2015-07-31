//
//  ShapeConcept.swift
//  SceneCraft
//
//  Created by Alicia Cicon on 7/30/15.
//  Copyright © 2015 Runemark. All rights reserved.
//

import Foundation

class ShapeConcept
{
    var shapes:[AbstractShape]
    var relationships:Array2D<SpatialRelationship>
    
    init()
    {
        self.shapes = [AbstractShape]()
        self.relationships = Array2D<SpatialRelationship>(x:0, y:0, filler:SpatialRelationship())
    }
    
    func addShape(shape:AbstractShape)
    {
        shapes.append(shape)
    }
}
