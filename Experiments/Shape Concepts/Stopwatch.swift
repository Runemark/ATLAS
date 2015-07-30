//
//  Stopwatch.swift
//  DeepGeneration
//
//  Created by Martin Mumford on 3/28/15.
//  Copyright (c) 2015 Martin Mumford. All rights reserved.
//

import Foundation

class Stopwatch {
    var startTime:CFAbsoluteTime
    
    init()
    {
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func start()
    {
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func mark() -> CFTimeInterval
    {
        return CFAbsoluteTimeGetCurrent() - startTime
    }
}

// Mark: Utility Methods

// How much faster or slower than a is b?
public func compareTimes(a:CFTimeInterval, b:CFTimeInterval) -> String {
    var modifier = "as fast as"
    
    if (a > b)
    {
        modifier = "\(a/b)x faster than"
    }
    else if (a < b)
    {
        modifier = "\((a/b)*100)% as fast as"
    }
    
    return "b is \(modifier) a"
}