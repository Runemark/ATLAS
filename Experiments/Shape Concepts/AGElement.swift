//
//  Element.swift
//  ATLAS
//
//  Created by Martin Mumford on 4/24/15.
//  Copyright (c) 2015 Brigham Young University. All rights reserved.
//

import Foundation

enum elementType {
    case ag_variable, ag_terminal
}

class AGElement {
    var type:elementType
    var expansions:[AGElement]
    
    init(type:elementType)
    {
        self.type = type
        self.expansions = [AGElement]()
    }
}