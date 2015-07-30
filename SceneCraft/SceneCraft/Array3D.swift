//
//  Array3D.swift
//  Obsidian
//
//  Created by Martin Mumford on 7/1/15.
//  Copyright (c) 2015 Brigham Young University. All rights reserved.
//

import Foundation

//////////////////////////////////////////////////////////////////////////////////////////
// 3D Volumes
//////////////////////////////////////////////////////////////////////////////////////////

struct Volume
{
    var x:Int
    var y:Int
    var z:Int
    
    var xLen:Int
    var yLen:Int
    var zLen:Int
    
    var vol:Int
        {
        get {
            return xLen*yLen*zLen
        }
    }
    
    func details() -> String
    {
        return "origin: \(x), \(y), \(z)   size: \(xLen), \(yLen), \(zLen)"
    }
    
    func origin() -> DiscreteCoord
    {
        return DiscreteCoord(x:x, y:y, z:z)
    }
    
    func size() -> VolumeSize
    {
        return VolumeSize(x:xLen, y:yLen, z:zLen)
    }
    
    func withinVolume(coord:DiscreteCoord) -> Bool
    {
        return ((coord.x >= x && coord.x < x+xLen) && (coord.y >= y && coord.y < y+yLen) && (coord.z >= z && coord.z < z+zLen))
    }
    
    func withinVolume(coord:Coord) -> Bool
    {
        return withinVolume(coord.roundDown())
    }
    
    mutating func moveToOrigin(origin:DiscreteCoord)
    {
        x = origin.x
        y = origin.y
        z = origin.z
    }
    
    mutating func expandToIncludeCoord(coord:DiscreteCoord)
    {
        if (coord.x < x)
        {
            xLen += x - coord.x
            x = coord.x
        }
        else if (coord.x >= x+xLen)
        {
            xLen = coord.x - x + 1
        }
        
        if (coord.y < y)
        {
            yLen += y - coord.y
            y = coord.y
        }
        else if (coord.y >= y+yLen)
        {
            yLen = coord.y - y + 1
        }
        
        if (coord.z < z)
        {
            zLen += z - coord.z
            z = coord.z
        }
        else if (coord.z >= z+zLen)
        {
            zLen = coord.z - z + 1
        }
    }
    
    func corners() -> Set<DiscreteCoord>
    {
        var cornerList = Set<DiscreteCoord>()
        
        cornerList.insert(DiscreteCoord(x:x, y:y, z:z))
        cornerList.insert(DiscreteCoord(x:x, y:y, z:z+zLen))
        cornerList.insert(DiscreteCoord(x:x, y:y+yLen, z:z))
        cornerList.insert(DiscreteCoord(x:x, y:y+yLen, z:z+zLen))
        
        cornerList.insert(DiscreteCoord(x:x+xLen, y:y, z:z))
        cornerList.insert(DiscreteCoord(x:x+xLen, y:y, z:z+zLen))
        cornerList.insert(DiscreteCoord(x:x+xLen, y:y+yLen, z:z))
        cornerList.insert(DiscreteCoord(x:x+xLen, y:y+yLen, z:z+zLen))
        
        return cornerList
    }
    
    mutating func expandToIncludeVolume(volume:Volume)
    {
        
    }
}

struct VolumeSize
{
    var x:Int
    var y:Int
    var z:Int
    
    subscript(index:Int) -> Int
        {
        get {
            switch (index)
            {
            case 0:
                return x
            case 1:
                return y
            case 2:
                return z
            default:
                print("BAD ACCESS IN VOLUME, INDEX:\(index)")
                return -1
            }
        }
        
        set {
            switch (index)
            {
            case 0:
                x = newValue
                break
            case 1:
                y = newValue
                break
            case 2:
                z = newValue
                break
            default:
                print("BAD ACCESS IN VOLUME, INDEX:\(index)")
                break
            }
        }
    }
    
    func details() -> String
    {
        return "[\(x), \(y), \(z)]"
    }
    
    var vol:Int
        {
        get {
            return x*y*z
        }
    }
}

// EQUATABLE
func ==(lhs:Volume, rhs:Volume) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.xLen == rhs.xLen && lhs.yLen == rhs.yLen && lhs.zLen == rhs.zLen
}

func ==(lhs:VolumeSize, rhs:VolumeSize) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

class Array3D<T>
{
    var xMax:Int
    var yMax:Int
    var zMax:Int
    var matrix:[T]
    
    init(x:Int, y:Int, z:Int, filler:T)
    {
        self.xMax = x
        self.yMax = y
        self.zMax = z
        matrix = Array<T>(count:(x*y*z), repeatedValue:filler)
    }
    
    subscript(x:Int, y:Int, z:Int) -> T {
        get
        {
            return matrix[(xMax*yMax * z) + (xMax * y) + x]
        }
        set
        {
            matrix[(xMax*yMax * z) + (xMax * y) + x] = newValue
        }
    }
    
    subscript(c:DiscreteCoord) -> T {
        get
        {
            return matrix[(xMax*yMax * c.z) + (xMax * c.y) + c.x]
        }
        set
        {
            matrix[(xMax*yMax * c.z) + (xMax * c.y) + c.x] = newValue
        }
    }
    
    func withinBounds(coord:DiscreteCoord) -> Bool
    {
        return withinBounds(coord.x, y:coord.y, z:coord.z)
    }
    
    func withinBounds(x:Int, y:Int, z:Int) -> Bool
    {
        return (x >= 0 && y >= 0 && z>=0 && x < xMax && y < yMax && z < zMax)
    }
    
    func random() -> DiscreteCoord
    {
        let x_rand = randIntBetween(0, stop:xMax-1)
        let y_rand = randIntBetween(0, stop:yMax-1)
        let z_rand = randIntBetween(0, stop:zMax-1)
        return DiscreteCoord(x:x_rand, y:y_rand, z:z_rand)
    }
    
    func immediateNeighborhood(center:DiscreteCoord) -> Set<DiscreteCoord>
    {
        var neighborhoodDiscreteCoordinates = Set<DiscreteCoord>()
        
        var uncheckedNeighbors = [DiscreteCoord]()
        
        uncheckedNeighbors.append(center.north())
        uncheckedNeighbors.append(center.east())
        uncheckedNeighbors.append(center.south())
        uncheckedNeighbors.append(center.west())
        uncheckedNeighbors.append(center.up())
        uncheckedNeighbors.append(center.down())
        
        for uncheckedNeighbor in uncheckedNeighbors
        {
            if (withinBounds(uncheckedNeighbor))
            {
                neighborhoodDiscreteCoordinates.insert(uncheckedNeighbor)
            }
        }
        
        return neighborhoodDiscreteCoordinates
    }
    
    func neighborhood(center:DiscreteCoord) -> Set<DiscreteCoord>
    {
        var neighborhoodDiscreteCoordinates = Set<DiscreteCoord>()
        
        for local_x in center.x-1...center.x+1
        {
            for local_y in center.y-1...center.y+1
            {
                for local_z in center.z-1...center.z+1
                {
                    let localDiscreteCoord = DiscreteCoord(x:local_x, y:local_y, z:local_z)
                    if (withinBounds(localDiscreteCoord) && localDiscreteCoord != center)
                    {
                        neighborhoodDiscreteCoordinates.insert(localDiscreteCoord)
                    }
                }
            }
        }
        
        return neighborhoodDiscreteCoordinates
    }
}

