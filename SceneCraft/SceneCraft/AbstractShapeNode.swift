//
//  AbstractShapeNode.swift
//  SceneCraft
//
//  Created by Alicia Cicon on 7/31/15.
//  Copyright © 2015 Runemark. All rights reserved.
//

import Foundation

enum AbstractProportion
{
    case PROP_AMBIGUOUS, PROP_FLAT, PROP_EQUAL, PROP_GREATER, PROP_MUCHGREATER
}

enum AbstractAxis
{
    case SIDE_A, SIDE_B, SIDE_C
}

enum AbstractDirection
{
    case AXIS_POSITIVE, AXIS_NEGATIVE
}

enum AbstractFill
{
    case FILL_COMPLETE, FILL_INCOMPLETE, FILL_AMBIGUOUS
}

struct AbstractPointer
{
    var axis:AbstractAxis
    var direction:AbstractDirection
}

struct AbstractProportions
{
    var sideA:AbstractProportion
    var sideB:AbstractProportion
    var sideC:AbstractProportion
}

// Arbitrary Granularity
    // Both components and not-components
// Overlapping Substructures

class AbstractShape
{
    var proportions:AbstractProportions
    var components:[AbstractShape]
    
    var top:AbstractPointer?
    var front:AbstractPointer?
    
    var fill:AbstractFill?
    
    init()
    {
        proportions = AbstractProportions(sideA:AbstractProportion.PROP_AMBIGUOUS, sideB:AbstractProportion.PROP_AMBIGUOUS, sideC:AbstractProportion.PROP_AMBIGUOUS)
        components = [AbstractShape]()
    }
    
    func isSurface(constrainedAxis:AbstractAxis)
    {
        switch (constrainedAxis)
        {
            case AbstractAxis.SIDE_A:
                proportions.sideA = AbstractProportion.PROP_FLAT
                break
            case AbstractAxis.SIDE_B:
                proportions.sideB = AbstractProportion.PROP_FLAT
                break
            case AbstractAxis.SIDE_C:
                proportions.sideC = AbstractProportion.PROP_FLAT
                break
        }
    }
}




// CHAIR

// ROOM
// A room is a floor with walls

// FLOOR
// A floor is a flat-z surface

// AESTHETIC:
// Generalize a pattern in higher dimensions
// For example, alternating B/W/B/W in a line: Generalize to 2D (checkerboard), Generalize to 3D (checkerboard surface)


// TECHNIQUE: Example, cover something. (so give it a cube, and have it cover that cube)
// IT DEVELOPS ITS OWN FUNCTION FOR PERFORMING THAT TASK
// What should I do next?
// I want this big thing. So I'll make a small thing and cover it over to make it bigger.
    // Where to put the core? How bout here?
    // Now let's cover it up.

// There are only 3 types of shapes in the world:
// 1. Generic Shape
// 2. Flattened Shape