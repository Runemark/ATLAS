//
//  Drawing.swift
//  ATLAS
//
//  Created by Martin Mumford on 4/20/15.
//  Copyright (c) 2015 Brigham Young University. All rights reserved.
//

import Foundation

struct Pixel {
    var x:Int
    var y:Int
    var v:Int
}

struct Coord {
    var x:Double
    var y:Double
}

class Drawing {
    var pixels:Array2D<Int>
    var actionBuffer = [Pixel]()
    
    init(width:Int, height:Int)
    {
        // x, numCols = width
        // y, numRows = height
        pixels = Array2D<Int>(rows:height, cols:width, filler:0)
    }
    
    func clear()
    {
        pixels.fill(0)
    }
    
    func addPixel(x:Int, y:Int, v:Int)
    {
        actionBuffer.append(Pixel(x:x, y:y, v:v))
    }
    
    func popBuffer()
    {
        if (actionBuffer.count > 0)
        {
            let nextCoord = actionBuffer.removeAtIndex(0)
            pixels[nextCoord.x, nextCoord.y] = nextCoord.v
        }
    }
    
    func randomPosition() -> Coord
    {
        let randomX = Double(randIntBetween(0, pixels.rows))
        let randomY = Double(randIntBetween(0, pixels.cols))
        
        return Coord(x:randomX, y:randomY)
    }
    
    // Returns the coordinates of all non-zero pixels
    func allNonZeroPixels() -> [Coord]
    {
        var nonZeroPixels = [Coord]()
        
        for x in 0..<pixels.rows
        {
            for y in 0..<pixels.cols
            {
                if (pixels[x,y] > 0)
                {
                    let coord = Coord(x:Double(x), y:Double(y))
                    nonZeroPixels.append(coord)
                }
            }
        }
        
        return nonZeroPixels
    }
    
    func centerOfMass() -> Coord
    {
        let nonZeroPixels = allNonZeroPixels()
        var sumX = 0.0
        var sumY = 0.0
        
        for pixelPos in nonZeroPixels
        {
            sumX += Double(pixelPos.x)
            sumY += Double(pixelPos.x)
        }
        
        return Coord(x:sumX/Double(nonZeroPixels.count), y:sumY/Double(nonZeroPixels.count))
    }
    
    func distanceBetweenPoints(a:Coord, b:Coord) -> Double
    {
        return sqrt(pow(a.x, 2) + pow(b.x, 2))
    }
}
