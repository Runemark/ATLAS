//
//  Matrix.swift
//  ATLAS
//
//  Created by Martin Mumford on 4/22/15.
//  Copyright (c) 2015 Brigham Young University. All rights reserved.
//

import Foundation

class RelationMatrix<S,T> {
    // A list of items
    var items:[S]
    
    // A matrix of relationships between items
    // Row -> Originating item index
    // Col -> Destination item index
    var relations:[Int:T]
    
    ////////////////////////////////////////////////////////////
    // MARK: Initialization
    ////////////////////////////////////////////////////////////
    
    convenience init(items:[S], filler:T)
    {
        self.init()
        
        self.items = items
        
        for x in 0..<items.count
        {
            for y in 0..<items.count
            {
                let index = "\(x),\(y)".hashValue
                relations[index] = filler
            }
        }
    }
    
    init()
    {
        self.items = [S]()
        self.relations = [Int:T]()
    }
    
    ////////////////////////////////////////////////////////////
    // MARK: Manipulation
    ////////////////////////////////////////////////////////////
    
    subscript(x:Int, y:Int) -> T? {
        get
        {
            let index = "\(x),\(y)".hashValue
            return relations[index]
        }
        set
        {
            let index = "\(x),\(y)".hashValue
            relations[index] = newValue
        }
    }
    
    // Adds the item to the end of the matrix (last entry), and returns the index of the item just added
    func addItem(item:S, filler:T) -> Int
    {
        let newItemIndex = items.count
        
        items.append(item)
        
        var indiciesToAdd = [Int]()
        
        for x in 0..<newItemIndex
        {
            let newRowIndex = "\(x),\(newItemIndex)".hashValue
            let newColIndex = "\(newItemIndex),\(x)".hashValue
            
            indiciesToAdd.append(newRowIndex)
            indiciesToAdd.append(newColIndex)
        }
        
        let newCornerIndex = "\(newItemIndex),\(newItemIndex)".hashValue
        
        indiciesToAdd.append(newCornerIndex)
        
        for index in indiciesToAdd
        {
            relations[index] = filler
        }
        
        return newItemIndex
    }
    
    func addSelfRelation(item:Int, relation:T)
    {
        addRelation(item, toItem:item, relation:relation)
    }
    
    func addSymmetricRelation(fromItem:Int, toItem:Int, relation:T)
    {
        addRelation(fromItem, toItem:toItem, relation:relation)
        addRelation(toItem, toItem:fromItem, relation:relation)
    }
    
    func addRelation(fromItem:Int, toItem:Int, relation:T)
    {
        let index = "\(fromItem),\(toItem)".hashValue
        relations[index] = relation
    }
    
    ////////////////////////////////////////////////////////////
    // MARK: Information
    ////////////////////////////////////////////////////////////
    
    func itemAtIndex(index:Int) -> S
    {
        return items[index]
    }
    
    func relationsFromItemAtIndex(originIndex:Int) -> [T]
    {
        var originatingRelations = [T]()
        
        for destinationIndex in 0..<items.count
        {
            let totalIndex = "\(originIndex),\(destinationIndex)".hashValue
            if let relation = relations[totalIndex]
            {
                originatingRelations.append(relation)
            }
        }
        
        return originatingRelations
    }
    
    func relationsToItemAtIndex(destinationIndex:Int) -> [T]
    {
        var terminatingRelations = [T]()
        
        for originIndex in 0..<items.count
        {
            let totalIndex = "\(originIndex),\(destinationIndex)".hashValue
            if let relation = relations[totalIndex]
            {
                terminatingRelations.append(relation)
            }
        }
        
        return terminatingRelations
    }
}