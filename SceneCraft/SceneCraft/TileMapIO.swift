//
//  TileMapIO.swift
//  SceneCraft
//
//  Created by Martin Mumford on 7/6/15.
//  Copyright (c) 2015 Brigham Young University. All rights reserved.
//

import Foundation

func stringToMap(string:String) -> TileMap?
{
    let mapComponents = string.componentsSeparatedByString("$")
    if (mapComponents.count == 2)
    {
        let metadata = mapComponents[0]
        let content = mapComponents[1]
        
        let metadataComponents = metadata.componentsSeparatedByString(".")
        if (metadataComponents.count == 2)
        {
            let dimensions = metadataComponents[0]
            let title = metadataComponents[1]
            
            let dimensionComponents = dimensions.componentsSeparatedByString("x")
            if (dimensionComponents.count == 3)
            {
                let x = dimensionComponents[0].intValue
                let y = dimensionComponents[1].intValue
                let z = dimensionComponents[2].intValue
                
                let map = TileMap(x:x, y:y, z:z)
                map.title = title
                
                var local_z = 0
                let z_components = content.componentsSeparatedByString("-")
                if (z_components.count == z)
                {
                    for z_component in z_components
                    {
                        var local_y = 0
                        let y_components = z_component.componentsSeparatedByString(",")
                        if (y_components.count == y)
                        {
                            for y_component in y_components
                            {
                                var local_x = 0
                                let x_components = y_component.componentsSeparatedByString(".")
                                if (x_components.count == x)
                                {
                                    for x_component in x_components
                                    {
                                        //                                        println("\(local_x),\(local_y),\(local_z)")
                                        map.grid[local_x, local_y, local_z] = x_component.intValue
                                        local_x++
                                    }
                                }
                                else
                                {
                                    print("WARNING: Malformed x components @ x,\(local_y),\(local_z)")
                                }
                                
                                local_y++
                            }
                        }
                        else
                        {
                            print("WARNING: Malformed y components @ y,\(local_z)")
                        }
                        
                        local_z++
                    }
                }
                else
                {
                    print("WARNING: Malformed z components")
                }
                
                return map
            }
            else
            {
                print("ERROR: Malformed Dimensions")
            }
        }
        else
        {
            print("ERROR: Malformed Metadata")
        }
    }
    
    return nil
}

func mapToString(map:TileMap) -> String
{
    var string = "\(map.grid.xMax)x\(map.grid.yMax)x\(map.grid.zMax).\(map.title)$"
    
    for z in 0..<map.grid.zMax
    {
        for y in 0..<map.grid.yMax
        {
            for x in 0..<map.grid.xMax
            {
                string += "\(map.grid[x,y,z])"
                if (x < map.grid.xMax-1)
                {
                    string += "."
                }
            }
            
            if (y < map.grid.yMax-1)
            {
                string += ","
            }
        }
        
        if (z < map.grid.zMax-1)
        {
            string += "-"
        }
    }
    
    return string
}

func writeTileMap(map:TileMap)
{
    let userDocumentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
    
    let filePath = userDocumentsPath.stringByAppendingPathComponent(map.title).stringByAppendingPathExtension("map")!
    let fileContents = mapToString(map)
    
    do
    {
        try fileContents.writeToFile(filePath, atomically:true, encoding:NSUTF8StringEncoding)
    }
    catch
    {
        
    }
}

func readTileMap(title:String) -> TileMap?
{
    let userDocumentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
    
    var mapRepresentation:TileMap?
    
    if let filePath = userDocumentsPath.stringByAppendingPathComponent(title).stringByAppendingPathExtension("map")
    {
        var fileContents = ""
        
        do
        {
            try fileContents = String(contentsOfFile:filePath, encoding:NSUTF8StringEncoding)
        }
        catch
        {
            
        }
        
        mapRepresentation = stringToMap(fileContents)
    }
    else
    {
        print("No map titled: '\(title)' found in user document directory")
    }
    
    return mapRepresentation
}