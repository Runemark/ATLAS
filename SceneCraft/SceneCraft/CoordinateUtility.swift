//
//  TileSpace.swift
//  SceneCraft
//
//  Created by Martin Mumford on 7/6/15.
//  Copyright (c) 2015 Brigham Young University. All rights reserved.
//

import Foundation
import SpriteKit

//////////////////////////////////////////////////////////////////////////////////////////
// Handy CGPoint Arithmatic
//////////////////////////////////////////////////////////////////////////////////////////

func +(lhs:CGPoint, rhs:CGPoint) -> CGPoint
{
    return CGPoint(x:lhs.x + rhs.x, y:lhs.y + rhs.y)
}

//////////////////////////////////////////////////////////////////////////////////////////
// 2D Screen Coordinates
//////////////////////////////////////////////////////////////////////////////////////////

struct LineSegment
{
    var a:Position
    var b:Position
}

struct Position
{
    var x:Double
    var y:Double
    
    func details() -> String
    {
        return "\(x),\(y)"
    }
    
    func toPoint() -> CGPoint
    {
        return CGPoint(x:CGFloat(x), y:CGFloat(y))
    }
    
    func roundDown() -> DiscretePosition
    {
        return DiscretePosition(x:Int(floor(x)), y:Int(floor(y)))
    }
}

struct DiscretePosition
{
    var x:Int
    var y:Int
    
    func details() -> String
    {
        return "\(x).\(y)"
    }
    
    mutating func shiftBy(other:DiscretePosition)
    {
        x += other.x
        y += other.y
    }
    
    func toPosition() -> Position
    {
        return Position(x:Double(x), y:Double(y))
    }
}

extension DiscretePosition : Hashable
{
    var hashValue:Int
    {
        return "\(x),\(y)".hashValue
    }
}

// EQUATABLE
func ==(lhs:DiscretePosition, rhs:DiscretePosition) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

//////////////////////////////////////////////////////////////////////////////////////////
// 3D Tile Coordinates
//////////////////////////////////////////////////////////////////////////////////////////

struct DiscreteCoord
{
    var x:Int
    var y:Int
    var z:Int
    
    func details() -> String
    {
        return "\(x),\(y),\(z)"
    }
    
    func north() -> DiscreteCoord
    {
        return DiscreteCoord(x:x, y:y+1, z:z)
    }
    
    func east() -> DiscreteCoord
    {
        return DiscreteCoord(x:x-1, y:y, z:z)
    }
    
    func south() -> DiscreteCoord
    {
        return DiscreteCoord(x:x, y:y-1, z:z)
    }
    
    func west() -> DiscreteCoord
    {
        return DiscreteCoord(x:x+1, y:y, z:z)
    }
    
    func up() -> DiscreteCoord
    {
        return DiscreteCoord(x:x, y:y, z:z+1)
    }
    
    func down() -> DiscreteCoord
    {
        return DiscreteCoord(x:x, y:y, z:z-1)
    }
}

// HASHABLE
extension DiscreteCoord : Hashable
{
    var hashValue:Int
    {
        return "\(x),\(y),\(z)".hashValue
    }
}

// EQUATABLE
func ==(lhs:DiscreteCoord, rhs:DiscreteCoord) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

struct Coord
{
    var x:Double
    var y:Double
    var z:Double
    
    func details() -> String
    {
        return "\(x),\(y),\(z)"
    }
    
    func roundDown() -> DiscreteCoord
    {
        return DiscreteCoord(x:Int(floor(x)), y:Int(floor(y)), z:Int(floor(z)))
    }
}

// HASHABLE
extension Coord: Hashable
{
    var hashValue:Int
        {
            return "\(x),\(y),\(z)".hashValue
    }
}

// EQUATABLE
func ==(lhs:Coord, rhs:Coord) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

//////////////////////////////////////////////////////////////////////////////////////////
// Screen-Tile Tile-Screen Conversion
//////////////////////////////////////////////////////////////////////////////////////////

func screenPositionForTile(tile:Coord, camera:Coord, tileWidth:CGFloat, tileHeight:CGFloat) -> Position
{
    let delta_x = tile.x - camera.x
    let delta_y = tile.y - camera.y
    let delta_z = tile.z - camera.z
    
    let width = Double(tileWidth)
    let height = Double(tileHeight)
    
    let screen_x = (delta_x*(0.5*width)) + (delta_y*(-0.5*width))
    let screen_y = (delta_x*(-0.25*height)) + (delta_y*(-0.25*height)) + (delta_z*(0.5*height))
    
    return Position(x:screen_x, y:screen_y)
}
