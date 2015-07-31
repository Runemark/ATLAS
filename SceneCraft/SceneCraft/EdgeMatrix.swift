//
//  RelationshipMatrix.swift
//  SceneCraft
//
//  Created by Alicia Cicon on 7/30/15.
//  Copyright © 2015 Runemark. All rights reserved.
//

import Foundation

class EdgeMatrix<T>
{
    var grid:[[T]]
    var fillerValue:T
    
    init(filler:T)
    {
        self.fillerValue = filler
        self.grid = [[T]]()
    }
    
    func addElement()
    {
        
    }
}