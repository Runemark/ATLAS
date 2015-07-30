//
//  BoolUtility.swift
//  SceneCraft
//
//  Created by Alicia Cicon on 7/21/15.
//  Copyright © 2015 Runemark. All rights reserved.
//

import Foundation

// all or nothing: both true, or both false
func &=(lhs:Bool, rhs:Bool) -> Bool
{
    return (lhs && rhs) || (!lhs && !rhs)
}

// exlcusive or (XOR): one is true, and the other false
infix operator ^^ {associativity left precedence 120}

func ^^(lhs:Bool, rhs:Bool) -> Bool
{
    return (lhs && !rhs) || (!lhs && rhs)
}