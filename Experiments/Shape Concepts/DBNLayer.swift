//
//  DBNLayer.swift
//  ATLAS
//
//  Created by Martin Mumford on 4/30/15.
//  Copyright (c) 2015 Brigham Young University. All rights reserved.
//

import Foundation

class DBNLayer {
    // Values
    var h1:[Int]
    
    var h:[Int]
    var q:[Double]
    
    var p:[Double]
    var x:[Int]
    
    var x1:[Int]
    
    // Weights
    var downWeights:Array2D<Double>
    var upWeights:Array2D<Double>
    
    // Biases
    var b:[Double]
    var c:[Double]
    
    // Information
    var visible:Int
    var hidden:Int
    
    // Parameters
    var lr = 0.1
    
    init(visible:Int, hidden:Int)
    {
        self.visible = visible
        self.hidden = hidden
        
        h1 = [Int](count:hidden, repeatedValue:0)
        
        h = [Int](count:hidden, repeatedValue:0)
        q = [Double](count:hidden, repeatedValue:Double(0))
        
        b = [Double](count:visible, repeatedValue:Double(0))
        
        downWeights = Array2D<Double>(rows:hidden, cols:visible, filler:Double(0.0))
        upWeights = Array2D<Double>(rows:visible, cols:hidden, filler:Double(0.0))
        
        c = [Double](count:hidden, repeatedValue:Double(0))
        
        p = [Double](count:visible, repeatedValue:Double(0))
        x = [Int](count:visible, repeatedValue:0)
        
        x1 = [Int](count:visible, repeatedValue:0)
        
        initializeWeights()
    }
    
    func initializeWeights()
    {
        randomWeights(&q)
        randomWeights(&b)
        
        randomWeights(&downWeights)
        randomWeights(&upWeights)
        
        randomWeights(&c)
        randomWeights(&p)
    }
    
    func randomWeights(inout matrix:Array2D<Double>)
    {
        for x in 0..<matrix.rows
        {
            for y in 0..<matrix.cols
            {
                matrix[x,y] = randNormalDouble()
            }
        }
    }
    
    func randomWeights(inout array:[Double])
    {
        for index in 0..<array.count
        {
            array[index] = Double(randNormalFloat())
        }
    }
    
    func loadInstance(instance:[Int])
    {
        for index in 0..<instance.count
        {
            x[index] = instance[index]
        }
    }
    
    func upNet(hiddenIndex:Int) -> Double
    {
        var net = Double(0)
        
        // Weighted sum of all x
        for visibleIndex in 0..<visible
        {
            net += upWeights[visibleIndex, hiddenIndex]*Double(x[visibleIndex])
        }
        
        // Add bias
        net += c[hiddenIndex]
        
        return net
    }
    
    func downNet(visibleIndex:Int) -> Double
    {
        var net = Double(0)
        
        for hiddenIndex in 0..<hidden
        {
            net += downWeights[hiddenIndex, visibleIndex]*Double(h[hiddenIndex])
        }
        
        // Add bias
        net += b[visibleIndex]
        
        return net
    }
    
    func sigmoid(value:Double) -> Double
    {
        return 1.0 / (1.0 - pow(M_E, (-1.0 * value)))
    }
    
    func sample(value:Double) -> Int
    {
        return weightedCoinFlip(value) ? 1 : 0
    }
    
    func trainOnDataset(instances:[[Int]])
    {
        var stoppingCriteriaMet = false
        
        for instance in instances
        {
            trainInstance(instance)
            
            // Check for stopping criteria
            
            if (stoppingCriteriaMet)
            {
                break
            }
        }
    }
    
    func trainInstance(instance:[Int])
    {
        loadInstance(instance)
        contrastiveDivergence(1)
    }
    
    func contrastiveDivergence(k:Int)
    {
        // Will cycle k-times
        for _ in 0..<k
        {
            for hiddenIndex in 0..<hidden
            {
                q[hiddenIndex] = sigmoid(upNet(hiddenIndex))
                h[hiddenIndex] = sample(q[hiddenIndex])
            }
            
            for visibleIndex in 0..<visible
            {
                p[visibleIndex] = sigmoid(downNet(visibleIndex))
                x[visibleIndex] = sample(p[visibleIndex])
            }
        }
        
        // Final time
        for hiddenIndex in 0..<hidden
        {
            for hiddenIndex in 0..<hidden
            {
                q[hiddenIndex] = sigmoid(upNet(hiddenIndex))
            }
        }
        
        // Update the weights
        var cumulativeDelta = 0.0
        for hiddenIndex in 0..<hidden
        {
            for visibleIndex in 0..<visible
            {
                let delta = Double(h1[hiddenIndex])*Double(x1[visibleIndex]) - q[hiddenIndex]*Double(x[visibleIndex])
                
                let currentDownWeight = downWeights[hiddenIndex,visibleIndex]
                downWeights[hiddenIndex,visibleIndex] = currentDownWeight + lr*delta
                
                let currentUpWeight = upWeights[visibleIndex,hiddenIndex]
                upWeights[visibleIndex,hiddenIndex] = currentUpWeight + lr*delta
            }
        }
        
    }
}