//
//  Stopwatch.swift
//  SceneCraft

import Foundation

class Stopwatch
{
    var startTime:CFAbsoluteTime
    
    init()
    {
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func start()
    {
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func mark() -> CFAbsoluteTime
    {
        return CFAbsoluteTimeGetCurrent() - startTime
    }
}