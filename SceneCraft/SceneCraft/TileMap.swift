//
//  TileMap.swift
//  SceneCraft
//
//  Created by Martin Mumford on 7/6/15.
//  Copyright (c) 2015 Brigham Young University. All rights reserved.
//

import Foundation

// 4 Faces
enum FaceType
{
    case FACE_N, FACE_E, FACE_S, FACE_W, FACE_U, FACE_D
}

// 8 Corners
enum CornerType
{
    case CORNER_U_NE, CORNER_U_NW, CORNER_U_SW, CORNER_U_SE, CORNER_D_NE, CORNER_D_NW, CORNER_D_SW, CORNER_D_SE
}

// 12 Edges
enum EdgeType
{
    case EDGE_NE, EDGE_NW, EDGE_SW, EDGE_SE, EDGE_UN, EDGE_UE, EDGE_US, EDGE_UW, EDGE_DN, EDGE_DE, EDGE_DS, EDGE_DW
}

struct ExposedEdges
{
    var ne:Bool
    var nw:Bool
    var sw:Bool
    var se:Bool
    var un:Bool
    var ue:Bool
    var us:Bool
    var uw:Bool
    var dn:Bool
    var de:Bool
    var ds:Bool
    var dw:Bool
}

struct IsoJoint
{
    var visible:Bool
    var critical:Bool
    var north:Bool
    var east:Bool
    var south:Bool
    var west:Bool
    var up:Bool
    var down:Bool
    
    func checkDirection(direction:FaceType) -> Bool
    {
        var directionPresent = false
        
        switch (direction)
        {
            case .FACE_U:
                directionPresent = up
                break
            case .FACE_S:
                directionPresent = south
                break
            case .FACE_W:
                directionPresent = west
                break
            case .FACE_D:
                directionPresent = down
                break
            case .FACE_N:
                directionPresent = north
                break
            case .FACE_E:
                directionPresent = east
                break
        }
        
        return directionPresent
    }
    
}

class TileMap
{
    var grid:Array3D<Int>
    var title:String = "Untitled"
    
    init(x:Int, y:Int, z:Int)
    {
        grid = Array3D<Int>(x:x, y:y, z:z, filler:0)
    }
    
    func visibilityMatrix() -> Array3D<Bool>
    {
        let matrix = Array3D<Bool>(x:grid.xMax, y:grid.yMax, z:grid.zMax, filler:false)
        
        let max_z = grid.zMax-1
        
        for y in 0..<grid.yMax
        {
            for x in 0..<grid.xMax
            {
                let projection = visibleProjection(x, y:y, z: max_z)
                for projectionCoordinate in projection
                {
                    matrix[projectionCoordinate] = true
                }
            }
        }
        
        let max_y = grid.yMax-1
        
        for z in 0..<grid.zMax
        {
            for x in 0..<grid.xMax
            {
                let projection = visibleProjection(x, y:max_y, z:z)
                for projectionCoordinate in projection
                {
                    matrix[projectionCoordinate] = true
                }
            }
        }
        
        let max_x = grid.xMax-1
        
        for z in 0..<grid.zMax
        {
            for y in 0..<grid.yMax
            {
                let projection = visibleProjection(max_x, y:y, z:z)
                for projectionCoordinate in projection
                {
                    matrix[projectionCoordinate] = true
                }
            }
        }
        
        return matrix
    }
    
    // Returns a projection along the axis of the camera, stopping at the first visible tile
    // (includes the specified tile)
    // WARXING: Here a camera angle of SOUTHWEST is assumed
    func visibleProjection(x:Int, y:Int, z:Int) -> [DiscreteCoord]
    {
        var projection = [DiscreteCoord]()
        
        var x_projection = x
        var y_projection = y
        var z_projection = z
        
        var visibleTileEncountered = false
        
        while (!visibleTileEncountered && x_projection >= 0 && y_projection >= 0 && z_projection >= 0)
        {
            if (grid[x_projection, y_projection, z_projection] > 0)
            {
                visibleTileEncountered = true
            }
            
            projection.append(DiscreteCoord(x:x_projection, y:y_projection, z:z_projection))
            
            x_projection--
            y_projection--
            z_projection--
        }
        
        return projection
    }
    
    // Accepts out of bounds arguments -- returns false
    func occupied(coord:DiscreteCoord) -> Bool
    {
        return (grid.withinBounds(coord) && grid[coord] > 0)
    }
    
    func visibleAir(coord:DiscreteCoord, visibilityMatrix:Array3D<Bool>) -> Bool
    {
        // is this tile (1) visible and (2) transparent?
        return (!occupied(coord) && isVisible(coord, visibilityMatrix:visibilityMatrix))
    }
    
    func isVisible(coord:DiscreteCoord, visibilityMatrix:Array3D<Bool>) -> Bool
    {
        let withinBounds = grid.withinBounds(coord)
        
        if (withinBounds)
        {
            return visibilityMatrix[coord]
        }
        else
        {
            if (isAboveBounds(coord))
            {
                return true
            }
            else if (isBelowBounds(coord))
            {
                if let nearestVisibleCoord = nearestValidCoord(coord)
                {
                    return visibilityMatrix[nearestVisibleCoord]
                }
            }
        }
        
        return true
    }
    
    func isAboveBounds(coord:DiscreteCoord) -> Bool
    {
        return coord.x >= grid.xMax || coord.y >= grid.yMax || coord.z >= grid.zMax
    }
    
    func isBelowBounds(coord:DiscreteCoord) -> Bool
    {
        return coord.x < 0 || coord.y < 0 || coord.z < 0
    }
    
    func nearestValidCoord(coord:DiscreteCoord) -> DiscreteCoord?
    {
        var searchingForCoord = true
        var tempCoord = coord
        
        while (searchingForCoord)
        {
            if (grid.withinBounds(tempCoord))
            {
                return tempCoord
            }
            else if (isAboveBounds(tempCoord))
            {
                searchingForCoord = false
                break
            }
            else
            {
                tempCoord = DiscreteCoord(x:tempCoord.x+1, y:tempCoord.y+1, z:tempCoord.z+1)
            }
        }
        
        return nil
    }
    
    func exposedEdgeMatrix(visibilityMatrix:Array3D<Bool>) -> Array3D<ExposedEdges>
    {
        let matrix = Array3D<ExposedEdges>(x:grid.xMax, y:grid.yMax, z:grid.zMax, filler:ExposedEdges(ne:false, nw:false, sw:false, se:false, un:false, ue:false, us:false, uw:false, dn:false, de:false, ds:false, dw:false))
        
        // Proceeds from EAST to WEST
        for x in 0..<grid.xMax
        {
            // Proceeds from SOUTH to NORTH
            for y in 0..<grid.yMax
            {
                // Proceeds from DOWN to UP
                for z in 0..<grid.zMax
                {
                    let coord = DiscreteCoord(x:x, y:y, z:z)
                    
                    if (visibilityMatrix[coord] && occupied(coord))
                    {
                        let n = coord.north()
                        let nw = n.west()
                        let e = coord.east()
                        let ne = n.east()
                        let s = coord.south()
//                        let se = s.east()
                        let w = coord.west()
                        let sw = s.west()
                        let u = coord.up()
                        let d = coord.down()
                        let un = u.north()
                        let ue = u.east()
                        let us = u.south()
                        let uw = u.west()
                        let dn = d.north()
                        let dw = d.west()

                        let vn = visibleAir(n, visibilityMatrix:visibilityMatrix)
                        let ve = visibleAir(e, visibilityMatrix:visibilityMatrix)
                        let vs = visibleAir(s, visibilityMatrix:visibilityMatrix)
                        let vw = visibleAir(w, visibilityMatrix:visibilityMatrix)
                        let vu = visibleAir(u, visibilityMatrix:visibilityMatrix)
                        let vd = visibleAir(d, visibilityMatrix:visibilityMatrix)
                        
                        let vne = visibleAir(ne, visibilityMatrix:visibilityMatrix)
                        let vnw = visibleAir(nw, visibilityMatrix:visibilityMatrix)
//                        let vse = visibleAir(se, visibilityMatrix:visibilityMatrix)
                        let vsw = visibleAir(sw, visibilityMatrix:visibilityMatrix)
                        let vun = visibleAir(un, visibilityMatrix:visibilityMatrix)
                        let vue = visibleAir(ue, visibilityMatrix:visibilityMatrix)
                        let vus = visibleAir(us, visibilityMatrix:visibilityMatrix)
                        let vuw = visibleAir(uw, visibilityMatrix:visibilityMatrix)
                        let vdn = visibleAir(dn, visibilityMatrix:visibilityMatrix)
                        let vdw = visibleAir(dw, visibilityMatrix:visibilityMatrix)
                        
                        // EDGE_NE
                        matrix[coord].ne = (vn && vun && (!vne || (vne && ve)))
                        // EDGE_NW
                        matrix[coord].nw = (vnw && (vn &= vw))
//                        matrix[coord].nw = (vn && (!vnw || (vnw && vw)))
                        // EDGE_SW
                        matrix[coord].sw = (vw && vuw && (!vsw || (vsw && vs)))
                        // EDGE_SE INVISIBLE
                        // EDGE_UN
                        matrix[coord].un = (vun && vnw && (vu &= vn))
                        // EDGE_UE
                        matrix[coord].ue = (vu && (!vue || (vue && ve)))
                        // EDGE_US
                        matrix[coord].us = (vu && (!vus || (vus && vs)))
                        // EDGE_UW
                        matrix[coord].uw = (vuw && (vu &= vw))
                        // EDGE_DN
                        matrix[coord].dn = (vn && vnw && (!vdn || (vdn && vd)))
                        // EDGE_DE INVISIBLE
                        // EDGE_DS INVISIBLE
                        // EDGE_DW
                        matrix[coord].dw = (vw && vnw && (!vdw || (vdw && vd)))
                        
                        
                    }
                }
            }
        }
        
        return matrix
    }
    
    func flattenedIsoGrid(visibleEdgeMatrix:Array3D<ExposedEdges>) -> Array2D<IsoJoint>
    {
        let flattenedXMax = 3 + (grid.xMax - 1) + (grid.zMax - 1)
        let flattenedYMax = 3 + (grid.yMax - 1) + (grid.zMax - 1)
        let filler = IsoJoint(visible:false, critical:false, north:false, east:false, south:false, west:false, up:false, down:false)
        
        let flattenedGrid = Array2D<IsoJoint>(x:flattenedXMax, y:flattenedYMax, filler:filler)
        
        for x in 0..<visibleEdgeMatrix.xMax
        {
            for y in 0..<visibleEdgeMatrix.yMax
            {
                for z in 0..<visibleEdgeMatrix.zMax
                {
                    let coord = DiscreteCoord(x:x, y:y, z:z)
                
                    let unw = flattenedPositionForTile(coord, corner:CornerType.CORNER_U_NW)
                    let une = flattenedPositionForTile(coord, corner:CornerType.CORNER_U_NE)
                    let use = flattenedPositionForTile(coord, corner:CornerType.CORNER_U_SE)
                    let usw = flattenedPositionForTile(coord, corner:CornerType.CORNER_U_SW)
                    let dnw = flattenedPositionForTile(coord, corner:CornerType.CORNER_D_NW)
                    let dne = flattenedPositionForTile(coord, corner:CornerType.CORNER_D_NE)
                    let dse = flattenedPositionForTile(coord, corner:CornerType.CORNER_D_SE)
                    let dsw = flattenedPositionForTile(coord, corner:CornerType.CORNER_D_SW)
                    
                    if (visibleEdgeMatrix[coord].nw)
                    {
                        flattenedGrid[unw].visible = true
                        flattenedGrid[dnw].visible = true
                        
                        flattenedGrid[unw].down = true
                        flattenedGrid[dnw].up = true
                    }
                    
                    if (visibleEdgeMatrix[coord].ne)
                    {
                        flattenedGrid[une].visible = true
                        flattenedGrid[dne].visible = true
                        
                        flattenedGrid[une].down = true
                        flattenedGrid[dne].up = true
                    }
                    
                    if (visibleEdgeMatrix[coord].se)
                    {
                        flattenedGrid[use].visible = true
                        flattenedGrid[dse].visible = true
                        
                        flattenedGrid[use].down = true
                        flattenedGrid[dse].up = true
                    }
                    
                    if (visibleEdgeMatrix[coord].sw)
                    {
                        flattenedGrid[usw].visible = true
                        flattenedGrid[dsw].visible = true
                        
                        flattenedGrid[usw].down = true
                        flattenedGrid[dsw].up = true
                    }
                    
                    if (visibleEdgeMatrix[coord].un)
                    {
                        flattenedGrid[une].visible = true
                        flattenedGrid[unw].visible = true
                        
                        flattenedGrid[une].west = true
                        flattenedGrid[unw].east = true
                    }
                    
                    if (visibleEdgeMatrix[coord].ue)
                    {
                        flattenedGrid[une].visible = true
                        flattenedGrid[use].visible = true
                        
                        flattenedGrid[une].south = true
                        flattenedGrid[use].north = true
                    }
                    
                    if (visibleEdgeMatrix[coord].us)
                    {
                        flattenedGrid[use].visible = true
                        flattenedGrid[usw].visible = true
                        
                        flattenedGrid[use].west = true
                        flattenedGrid[usw].east = true
                    }
                    
                    if (visibleEdgeMatrix[coord].uw)
                    {
                        flattenedGrid[unw].visible = true
                        flattenedGrid[usw].visible = true
                        
                        flattenedGrid[unw].south = true
                        flattenedGrid[usw].north = true
                    }
                    
                    if (visibleEdgeMatrix[coord].dn)
                    {
                        flattenedGrid[dne].visible = true
                        flattenedGrid[dnw].visible = true
                        
                        flattenedGrid[dne].west = true
                        flattenedGrid[dnw].east = true
                    }
                    
                    if (visibleEdgeMatrix[coord].de)
                    {
                        flattenedGrid[dne].visible = true
                        flattenedGrid[dse].visible = true
                        
                        flattenedGrid[dne].south = true
                        flattenedGrid[dse].north = true
                    }
                    
                    if (visibleEdgeMatrix[coord].ds)
                    {
                        flattenedGrid[dse].visible = true
                        flattenedGrid[dsw].visible = true
                        
                        flattenedGrid[dse].west = true
                        flattenedGrid[dsw].east = true
                    }
                    
                    if (visibleEdgeMatrix[coord].dw)
                    {
                        flattenedGrid[dnw].visible = true
                        flattenedGrid[dsw].visible = true
                        
                        flattenedGrid[dnw].south = true
                        flattenedGrid[dsw].north = true
                    }
                }
            }
        }
        
        // Check for critical corners (a joint with a break)
        for x in 0..<flattenedGrid.xMax
        {
            for y in 0..<flattenedGrid.yMax
            {
                let joint = flattenedGrid[x,y]
                
                let break_ns = joint.north ^^ joint.south
                let break_ew = joint.east ^^ joint.west
                let break_ud = joint.up ^^ joint.down
                
                if (break_ns || break_ew || break_ud)
                {
                    flattenedGrid[x,y].critical = true
                }
            }
        }
        
        return flattenedGrid
    }
    
    func nextCriticalJointInDirection(source:DiscretePosition, direction:FaceType, flattenedGrid:Array2D<IsoJoint>) -> DiscretePosition?
    {
        var currentJoint = source
        
        var increment = DiscretePosition(x:0, y:0)
        let oppositeDirection = oppositeFace(direction)
        
        switch (direction)
        {
            case .FACE_U:
                increment.x = -1
                increment.y = -1
                break
            case .FACE_S:
                increment.x = 0
                increment.y = -1
                break
            case .FACE_W:
                increment.x = 1
                increment.y = 0
                break
            case .FACE_D:
                increment.x = 1
                increment.y = 1
                break
            case .FACE_N:
                increment.x = 0
                increment.y = 1
                break
            case .FACE_E:
                increment.x = -1
                increment.y = 0
                break
        }
        
        var jointFound = false
        var finalJoint:DiscretePosition?
        
        currentJoint.shiftBy(increment)
        while (!jointFound && flattenedGrid.withinBounds(source.x, y:source.y))
        {
            let nextJoint = flattenedGrid[currentJoint]
            
            if (nextJoint.critical && nextJoint.checkDirection(oppositeDirection))
            {
                jointFound = true
                finalJoint = currentJoint
            }
            
            currentJoint.shiftBy(increment)
        }
        
        return finalJoint
    }
    
    func lineSegmentsForCriticalCorners(flattenedGrid:Array2D<IsoJoint>) -> [LineSegment]
    {
        var lines = [LineSegment]()
        
        for x in 0..<flattenedGrid.xMax
        {
            for y in 0..<flattenedGrid.yMax
            {
                let position = DiscretePosition(x:x, y:y)
                
                let corner = flattenedGrid[position]
                
                if (corner.critical)
                {
                    if (corner.up)
                    {
                        let nextJointPosition = nextCriticalJointInDirection(position, direction:FaceType.FACE_U, flattenedGrid:flattenedGrid)!
                        
                        if (flattenedGrid[nextJointPosition].down)
                        {
                            let line = LineSegment(a:position.toPosition(), b:nextJointPosition.toPosition())
                            lines.append(line)
                            
                            flattenedGrid[position].up = false
                            flattenedGrid[nextJointPosition].down = false
                        }
                    }
                    
                    if (corner.down)
                    {
                        let nextJointPosition = nextCriticalJointInDirection(position, direction:FaceType.FACE_D, flattenedGrid:flattenedGrid)!
                        
                        if (flattenedGrid[nextJointPosition].up)
                        {
                            let line = LineSegment(a:position.toPosition(), b:nextJointPosition.toPosition())
                            lines.append(line)
                            
                            flattenedGrid[position].down = false
                            flattenedGrid[nextJointPosition].up = false
                        }
                    }
                    
                    if (corner.north)
                    {
                        let nextJointPosition = nextCriticalJointInDirection(position, direction:FaceType.FACE_N, flattenedGrid:flattenedGrid)!
                        
                        if (flattenedGrid[nextJointPosition].south)
                        {
                            let line = LineSegment(a:position.toPosition(), b:nextJointPosition.toPosition())
                            lines.append(line)
                            
                            flattenedGrid[position].north = false
                            flattenedGrid[nextJointPosition].south = false
                        }
                    }
                    
                    if (corner.south)
                    {
                        let nextJointPosition = nextCriticalJointInDirection(position, direction:FaceType.FACE_S, flattenedGrid:flattenedGrid)!
                        
                        if (flattenedGrid[nextJointPosition].north)
                        {
                            let line = LineSegment(a:position.toPosition(), b:nextJointPosition.toPosition())
                            lines.append(line)
                            
                            flattenedGrid[position].south = false
                            flattenedGrid[nextJointPosition].north = false
                        }
                    }
                    
                    if (corner.east)
                    {
                        let nextJointPosition = nextCriticalJointInDirection(position, direction:FaceType.FACE_E, flattenedGrid:flattenedGrid)!
                        
                        if (flattenedGrid[nextJointPosition].west)
                        {
                            let line = LineSegment(a:position.toPosition(), b:nextJointPosition.toPosition())
                            lines.append(line)
                            
                            flattenedGrid[position].east = false
                            flattenedGrid[nextJointPosition].west = false
                        }
                    }
                    
                    if (corner.west)
                    {
                        let nextJointPosition = nextCriticalJointInDirection(position, direction:FaceType.FACE_W, flattenedGrid:flattenedGrid)!
                        
                        if (flattenedGrid[nextJointPosition].east)
                        {
                            let line = LineSegment(a:position.toPosition(), b:nextJointPosition.toPosition())
                            lines.append(line)
                            
                            flattenedGrid[position].west = false
                            flattenedGrid[nextJointPosition].east = false
                        }
                    }
                }
            }
        }
        
        return lines
    }
    
    func flattenedPositionForTile(tile:DiscreteCoord, corner:CornerType) -> DiscretePosition
    {
        var origin = flattenedPositionForTileOrigin(tile)
        
        switch (corner)
        {
            case CornerType.CORNER_U_NW:
                break
            case CornerType.CORNER_U_NE:
                origin.shiftBy(DiscretePosition(x:-1, y:0))
                break
            case CornerType.CORNER_U_SE:
                origin.shiftBy(DiscretePosition(x:-1, y:-1))
                break
            case CornerType.CORNER_U_SW:
                origin.shiftBy(DiscretePosition(x:0, y:-1))
                break
            case CornerType.CORNER_D_NW:
                origin.shiftBy(DiscretePosition(x:+1, y:+1))
                break
            case CornerType.CORNER_D_NE:
                origin.shiftBy(DiscretePosition(x:0, y:+1))
                break
            case CornerType.CORNER_D_SE:
                break
            case CornerType.CORNER_D_SW:
                origin.shiftBy(DiscretePosition(x:+1, y:0))
                break
        }
        
        return origin
    }
    
    func flattenedPositionForTileOrigin(tile:DiscreteCoord) -> DiscretePosition
    {
        return DiscretePosition(x:grid.zMax + tile.x - tile.z, y:grid.zMax + tile.y - tile.z)
    }
    
    func oppositeFace(direction:FaceType) -> FaceType
    {
        var oppositeDirection = FaceType.FACE_U
        
        switch (direction)
        {
            case .FACE_U:
                oppositeDirection = FaceType.FACE_D
                break
            case .FACE_S:
                oppositeDirection = FaceType.FACE_N
                break
            case .FACE_W:
                oppositeDirection = FaceType.FACE_E
                break
            case .FACE_D:
                oppositeDirection = FaceType.FACE_U
                break
            case .FACE_N:
                oppositeDirection = FaceType.FACE_S
                break
            case .FACE_E:
                oppositeDirection = FaceType.FACE_W
                break
        }
        
        return oppositeDirection
    }
}