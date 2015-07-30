//
//  SKSpriteNodeExtension.swift
//  ACFramework
//
//  Created by Martin Mumford on 6/4/15.
//  Copyright (c) 2015 Runemark Studios. All rights reserved.
//

import Foundation
import SpriteKit

extension SKSpriteNode
{
    func resizeNode(x:CGFloat, y:CGFloat)
    {
        // ORIGINAL image dimensions
        let original_x = self.size.width/self.xScale
        let original_y = self.size.height/self.yScale
        
        self.xScale = x/original_x
        self.yScale = y/original_y
    }
}