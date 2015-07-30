//
//  Angle.swift
//  ACFramework
//
//  Created by Alicia Cicon on 7/13/15.
//  Copyright © 2015 Runemark. All rights reserved.
//

import Foundation
import SpriteKit

func radialOffset(position:CGPoint, radius:CGFloat, angle:CGFloat) -> CGPoint
{
    // Calculate the x and y components on the unit circle
    let x_component = cos(radians(angle))
    let y_component = sin(radians(angle))
    
    return CGPointMake(position.x + x_component*radius, position.y + y_component*radius)
}

func radians(degrees:CGFloat) -> CGFloat
{
    return (CGFloat(M_PI) * degrees) / CGFloat(180.0)
}

func degrees(radians:CGFloat) -> CGFloat
{
    return (radians * CGFloat(180.0)) / CGFloat(M_PI)
}