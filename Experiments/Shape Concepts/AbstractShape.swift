//
//  AbstractShape.swift
//  ATLAS
//
//  Created by Martin Mumford on 4/20/15.
//  Copyright (c) 2015 Brigham Young University. All rights reserved.
//

import Foundation

enum spatialRelationship {
    case none, adjacentTo, nearTo, farFrom, enclosedBy, encloses, leftOf, rightOf, above, below, connectedByLine
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MISSING FEATURES:
//  Still need some way of representing PROPORTION (size), VISUAL SIGNIFICANCE
//  Rotation of a shape
//  Scale of a shape
//  Relative Scale (proportion) -> Square vs. Rectangle will require this.
//  Paralell vs. Perpendicular vs. Other (relative angle/direction) -> Square vs. Rectangle. vs Parallelogram will require this.
//  Similar Representations (might be technique territory) "Like a square (abstractShape) but with rounded corners"
//  Shape decomposition (Abstract Shape Approximation Algorithm) n
//  Symmetry (vertical, horizontal, rotational, translational, scale)
//  Guide Lines (arrangement) -> abstractShapes that lie along a line, or a curve. (for example, [bubbles] rising from [a cauldron])
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class AbstractShape {
    var components:RelationMatrix<AbstractShape, spatialRelationship>
    
    init()
    {
        components = RelationMatrix<AbstractShape, spatialRelationship>()
    }
    
    func addComponent(component:AbstractShape) -> Int
    {
        return components.addItem(component, filler:spatialRelationship.none)
    }
}