//
//  RelationshipMatrix.swift
//  SceneCraft
//
//  Created by Alicia Cicon on 7/30/15.
//  Copyright © 2015 Runemark. All rights reserved.
//

import Foundation

class Edge<T>
{
    var value:T?
    
    convenience init(val:T)
    {
        self.init()
        self.value = val
    }
    
    init()
    {
        
    }
}

class Graph<S,T>
{
    var nodes:[S]
    var edges:[[Edge<T>]]
    
    init()
    {
        self.nodes = [S]()
        self.edges = [[Edge<T>]]()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // NODE OPERATIONS
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func addNode(node:S)
    {
        // Add the new node to the end of the list of nodes
        nodes.append(node)
        
        // Add a new row and column to the edge matrix
        let newNodeIndex = nodes.count
        for _ in 0..<newNodeIndex
        {
            // Add new row
            edges.append([Edge]())
            // Fill new row with blank edges
            for col in 0..<newNodeIndex
            {
                edges[newNodeIndex][col] = Edge()
            }
            
            // Add new column to all rows
            for row in 0..<newNodeIndex-1
            {
                edges[row].append(Edge<T>())
            }
        }
    }
    
    func removeFirstNode()
    {
        removeNodeAtIndex(0)
    }
    
    func removeLastNode()
    {
        removeNodeAtIndex(nodes.count-1)
    }
    
    func removeNodeAtIndex(index:Int)
    {
        if (index >= 0 && index < nodes.count)
        {
            // Remove the node from the node list
            nodes.removeAtIndex(index)
            
            // Remove that row of edges
            edges.removeAtIndex(index)
            
            // Remove that column from every remaining row of edges
            for row in 0..<edges.count
            {
                edges[row].removeAtIndex(index)
            }
        }
        else
        {
            print("ERROR: Attempted to remove node \(index) from EdgeMatrix with only \(nodes.count) nodes")
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // EDGE OPERATIONS
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
}