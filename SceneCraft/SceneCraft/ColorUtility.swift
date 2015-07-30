//
//  ColorUtil.swift
//  SceneCraft
//
//  Created by Alicia Cicon on 7/10/15.
//  Copyright (c) 2015 Runemark. All rights reserved.
//

import Foundation
import SpriteKit

extension UIColor
{
    func red() -> CGFloat
    {
        return CGColorGetComponents(self.CGColor)[0]
    }
    
    func green() -> CGFloat
    {
        return CGColorGetComponents(self.CGColor)[1]
    }
    
    func blue() -> CGFloat
    {
        return CGColorGetComponents(self.CGColor)[2]
    }
    
    func rgb() -> [CGFloat]
    {
        var components = [CGFloat]()
        
        components.append(red())
        components.append(green())
        components.append(blue())
        
        return components
    }
}

func blendedLinearPalette(a:UIColor, b:UIColor, totalSteps:Int) -> [UIColor]
{
    var palette = [UIColor]()
    
    let blendStep = 1.0 / Double(totalSteps-1)
    var currentBlendFactor = 0.0
    
    for _ in 0..<totalSteps
    {
        palette.append(blendColors(a, b:b, blendFactor:currentBlendFactor))
        currentBlendFactor += blendStep
    }
    
    return palette
}

// Return a color in-between colors A and B,
// where a blendFactor of 0.0 is the color A, and a blendFactor of 1.0 is the color B
// Ingores alpha (always returns a color with alpha of 1.0
func blendColors(a:UIColor, b:UIColor, blendFactor:Double) -> UIColor
{
    let a_components = a.rgb()
    let b_components = b.rgb()
    
    var blend_r = CGFloat(0)
    var blend_g = CGFloat(0)
    var blend_b = CGFloat(0)
    
    let delta_r = (a_components[0] == b_components[0]) ? 0.0 : b_components[0] - a_components[0]
    blend_r = a_components[0] + CGFloat(blendFactor)*delta_r
    
    let delta_g = (a_components[1] == b_components[1]) ? 0.0 : b_components[1] - a_components[1]
    blend_g = a_components[1] + CGFloat(blendFactor)*delta_g
    
    let delta_b = (a_components[2] == b_components[2]) ? 0.0 : b_components[2] - a_components[2]
    blend_b = a_components[2] + CGFloat(blendFactor)*delta_b
    
    return UIColor(red:blend_r, green:blend_g, blue:blend_b, alpha:CGFloat(1.0))
}