//
//  2DPixelSpatialCore.swift
//  ATLAS
//
//  Created by Martin Mumford on 5/16/15.
//  Copyright (c) 2015 Brigham Young University. All rights reserved.
//

import Foundation

func octant4(x0:Double, x1:Double, y0:Double, y1:Double) {
    let deltaX = x1 - x0
    let deltaY = y1 - y0
    let sign = sign(deltaY)
    var error = 0
    var deltaError = abs(deltaX/deltaY)
    
    var y = y0
    
    for x in x0..x1
    {
        // plot (x,y)
        error += deltaError
        while (error >= 0.5)
        {
            // plot (x,y)
            y += sign
            error += -1.0
        }
    }
}

func sign(value:Double) -> Double {
    return (value < 0) ? -1.0 : 1.0
}