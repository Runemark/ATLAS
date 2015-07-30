//
//  DensityMap.swift
//  SceneCraft
//
//  Created by Alicia Cicon on 7/10/15.
//  Copyright (c) 2015 Runemark. All rights reserved.
//

import Foundation

class DensityMap
{
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Variables
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var xMax:Int
    var yMax:Int
    var zMax:Int
    
    var xGrid:Array2D<Int>
    var yGrid:Array2D<Int>
    var zGrid:Array2D<Int>
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Initialization
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    convenience init(grid:Array3D<Int>)
    {
        // Count all non-zero labels by default
        self.init(grid:grid, label:-1)
    }
    
    // If label is -1, then ALL non-zero labels are counted towards density, otherwise, only the specified label is counted
    init(grid:Array3D<Int>, label:Int)
    {
        self.xMax = grid.xMax
        self.yMax = grid.yMax
        self.zMax = grid.zMax
        
        // In the xGrid, we are collapsing the x axis
        // Thus, its x-axis = "y", and its y-axis = "z"
        // Its "origin" is in the bottom-right
        xGrid = Array2D<Int>(x:yMax, y:zMax, filler:0)
        
        // In the yGrid, we are collapsing the y axis
        // Thus, its x-axis = "x", and its y-axis = "z"
        // Its "origin" is in the bottom-left
        yGrid = Array2D<Int>(x:xMax, y:zMax, filler:0)
        
        // In the zGrid, we are collapsing the z axis
        // Thus, its x-axis = "x", and its y-axis = "y"
        // Its "origin" is in the top-left
        zGrid = Array2D<Int>(x:xMax, y:yMax, filler:0)
        
        for x in 0..<xMax
        {
            for y in 0..<yMax
            {
                for z in 0..<zMax
                {
                    if (label == -1)
                    {
                        if (grid[x,y,z] > 0)
                        {
                            addCoord(x, y:y, z:z)
                        }
                    }
                    else
                    {
                        if (grid[x,y,z] == label)
                        {
                            addCoord(x, y:y, z:z)
                        }
                    }
                }
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Information
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // For x-axis density, the origin is bottom-left
    func densityInXGrid(trueY:Int, trueZ:Int) -> Int
    {
        return xGrid[trueY, trueZ]
    }
    
    // For y-axis density, the origin is bottom-right
    func densityInYGrid(trueX:Int, trueZ:Int) -> Int
    {
        return yGrid[trueX, trueZ]
    }
    
    // For z-axis density, the origin is top-left
    func densityInZGrid(trueX:Int, trueY:Int) -> Int
    {
        return zGrid[trueX, trueY]
    }
    
    func densityProportionInXGrid(trueY:Int, trueZ:Int) -> Double
    {
        return Double(densityInXGrid(trueY, trueZ:trueZ)) / Double(xMax)
    }
    
    func densityProportionInYGrid(trueX:Int, trueZ:Int) -> Double
    {
        return Double(densityInYGrid(trueX, trueZ:trueZ)) / Double(yMax)
    }
    
    func densityProportionInZGrid(trueX:Int, trueY:Int) -> Double
    {
        return Double(densityInZGrid(trueX, trueY:trueY)) / Double(zMax)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Manipulation
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func clear()
    {
        xGrid.fill(0)
        yGrid.fill(0)
        zGrid.fill(0)
    }
    
    private func addCoord(x:Int, y:Int, z:Int)
    {
        // Modify the appropriate slot on the x, y, and z grids
        xGrid[y, z]++
        yGrid[x, z]++
        zGrid[x, y]++
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}