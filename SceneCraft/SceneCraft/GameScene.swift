//
//  LogisticsScene.swift
//  Terms and conditions
//
//  Created by Alicia Cicon on 7/14/15.
//  Copyright © 2015 Runemark. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene
{
    var window:CGSize = CGSize(width:0, height:0)
    var center:CGPoint = CGPoint(x:0, y:0)
    
    var backgroundNode = SKSpriteNode()
//    var backgroundColor = UIColor(red:0.1, green:0.1, blue:0.1, alpha:1.0)
    
    override func didMoveToView(view: SKView)
    {
        // This is apparently very important in SpriteKit!
        self.size = view.bounds.size
        
        window = UIScreen.mainScreen().bounds.size
        center = CGPoint(x:window.width/2.0, y:window.height/2.0)
        
        self.backgroundColor = UIColor(red:0.156, green:0.165, blue:0.188, alpha:1.0)
        
        let tileWidth = CGFloat(30.0)
        let tileHeight = CGFloat(30.0)
        
        let cameraPosition = Coord(x:0, y:0, z:0)
        
        // SMALL CHAIR
//        let scene = stringToMap("3x2x3.test$1.1.1,1.1.1-1.1.1,1.0.1-1.1.1,0.0.0")!
        
        // MEDIUM CHAIR
//        let scene = stringToMap("3x3x6.test$1.0.1,0.0.0,1.0.1-1.0.1,0.0.0,1.0.1-1.1.1,1.1.1,1.1.1-1.1.1,0.0.0,0.0.0-1.1.1,0.0.0,0.0.0-1.1.1,0.0.0,0.0.0")!
        
        // OFFICE CHAIR
//        let scene = stringToMap("5x3x7.test$0.1.0.1.0,0.0.1.0.0,0.1.0.1.0-0.0.0.0.0,0.0.1.0.0,0.0.0.0.0-0.0.0.0.0,0.0.1.0.0,0.0.0.0.0-0.1.1.1.0,0.1.1.1.0,0.1.1.1.0-0.1.1.1.0,1.0.0.0.1,1.0.0.0.1-0.1.1.1.0,0.0.0.0.0,0.0.0.0.0-0.1.1.1.0,0.0.0.0.0,0.0.0.0.0")!
        
        // OBLIQUE PYRAMID
        let scene = stringToMap("4x4x4.test$1.1.1.1,1.1.1.1,1.1.1.1,1.1.1.1-1.1.1.0,1.1.1.0,1.1.1.0,0.0.0.0-1.1.0.0,1.1.0.0,0.0.0.0,0.0.0.0-1.0.0.0,0.0.0.0,0.0.0.0,0.0.0.0")!
        
        writeTileMap(scene)
        let testScene = readTileMap(scene.title)
        
//        let regionMap = scene.decomposeVolume()
        
        let visibilityMatrix = scene.visibilityMatrix()
//        let edgeMatrix = scene.exposedEdgeMatrix(visibilityMatrix)
//        let flattenedGrid = scene.flattenedIsoGrid(edgeMatrix)
//        let lineSegments = scene.lineSegmentsForCriticalCorners(flattenedGrid)
        
        for x in 0..<scene.grid.xMax
        {
            for y in 0..<scene.grid.yMax
            {
                for z in 0..<scene.grid.zMax
                {
                    if (scene.grid[x,y,z] > 0 && visibilityMatrix[x,y,z])
                    {
                        let sprite = SKSpriteNode(imageNamed:"3.png")
                        sprite.resizeNode(tileWidth, y:tileHeight)
                        let position = screenPositionForTile(Coord(x:Double(x), y:Double(y), z:Double(z)), camera:cameraPosition, tileWidth: tileWidth, tileHeight:tileHeight)
                        sprite.position = position.toPoint() + center
                        
                        self.addChild(sprite)
                    }
                }
            }
        }
        
//        let path:CGMutablePathRef = CGPathCreateMutable()
//        let lines = SKShapeNode(path:path)
//        
//        for line in lineSegments
//        {
//            let iso_a = line.a
//            let iso_b = line.b
//            
//            let projected_a = Coord(x:Double(iso_a.x), y:Double(iso_a.y), z:Double(scene.grid.zMax))
//            let projected_b = Coord(x:Double(iso_b.x), y:Double(iso_b.y), z:Double(scene.grid.zMax))
//            
//            let screen_a = screenPositionForTile(projected_a, camera:cameraPosition, tileWidth:tileWidth, tileHeight:tileHeight)
//            let screen_b = screenPositionForTile(projected_b, camera:cameraPosition, tileWidth:tileWidth, tileHeight:tileHeight)
//            
//            let a_position = screen_a.toPoint() + center
//            let b_position = screen_b.toPoint() + center
//            
//            // Draw the line between points a and b
//            CGPathMoveToPoint(path, nil, a_position.x, a_position.y)
//            CGPathAddLineToPoint(path, nil, b_position.x, b_position.y)
//        }
//        
//        lines.path = path
//        lines.strokeColor = UIColor(red:0.247, green:0.255, blue:0.275, alpha:1.0)
////        lines.strokeColor = UIColor.blackColor()
//        lines.lineWidth = 0.1
//        self.addChild(lines)
        
        
        
//        for x in 0..<flattenedGrid.xMax
//        {
//            for y in 0..<flattenedGrid.yMax
//            {
//                if (flattenedGrid[x,y].visible)
//                {
//                    // Determine the position of this POINT
//                    let projectedTileOrigin = Coord(x:Double(x), y:Double(y), z:Double(scene.grid.zMax))
//                    let screenPosition = screenPositionForTile(projectedTileOrigin, camera:cameraPosition, tileWidth:tileWidth, tileHeight:tileHeight)
//
//                    let sprite = SKSpriteNode(imageNamed:"square.png")
//                    sprite.resizeNode(2, y:2)
//                    sprite.position = screenPosition.toPoint() + center
//
//                    if (flattenedGrid[x,y].critical)
//                    {
//                        sprite.color = UIColor.yellowColor()
//                    }
//                    else
//                    {
//                        sprite.color = UIColor.redColor()
//                    }
//
//                    sprite.colorBlendFactor = 1.0
//                    
//                    self.addChild(sprite)
//                }
//            }
//        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        
    }
}