//
//  AbstractShape.swift
//  SceneCraft
//
//  Created by Alicia Cicon on 7/30/15.
//  Copyright © 2015 Runemark. All rights reserved.
//

import Foundation

enum AbstractProportion
{
    case PROP_EQUAL, PROP_GREATER, PROP_MUCHGREATER
}

struct AbstractProportions
{
    var height:AbstractProportion
    var sideA:AbstractProportion
    var sideB:AbstractProportion
}

class AbstractShape
{
    var proportions:AbstractProportions
    
    init()
    {
        proportions = AbstractProportions(height:AbstractProportion.PROP_EQUAL, sideA:AbstractProportion.PROP_EQUAL, sideB:AbstractProportion.PROP_EQUAL)
    }
}