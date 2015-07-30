//
//  RandomExtensions.swift
//  DeepGeneration
//
//  Created by Martin Mumford on 3/28/15.
//  Copyright (c) 2015 Martin Mumford. All rights reserved.
//

import Foundation

// Returns a random bool with 50% probability of getting true, 50% probability of getting false
func coinFlip() -> Bool {
    let coinFlip = randIntBetween(0, 1)
    if (coinFlip > 0)
    {
        return true
    }
    else
    {
        return false
    }
}

// Returns with a <trueProb> probability of getting true, and a <1-trueProb> probability of getting false
func weightedCoinFlip(trueProb:Double) -> Bool {
    return (trueProb < randNormalDouble())
}

// Returns a random int between the specified ranges (inclusive)
func randIntBetween(start:Int, stop:Int) -> Int {
    var offset = 0
    
    if start < 0
    {
        offset = abs(start)
    }
    
    let mini = UInt32(start + offset)
    let maxi = UInt32(stop + offset)
    
    return Int(mini + arc4random_uniform(maxi + 1 - mini)) - offset
}

// Returns a random float between 0 and 1
func randNormalFloat() -> Float {
    return Float(arc4random()) / Float(UINT32_MAX)
}

func randNormalDouble() -> Double {
    return Double(arc4random()) / Double(UINT32_MAX)
}