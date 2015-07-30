//
//  Array2D.swift
//
//  Created by Martin Mumford, Runemark Studios on 3/10/15
//  This class is licensed under the CC0 "Public Domain" license (do whatever you want with it)
//
//  Inspired by Stede Troisi at http://blog.trolieb.com/trouble-multidimensional-arrays-swift/

import Foundation

class Array2D<T> {
    var cols:Int, rows:Int
    var matrix:[T]
    
    // max x (rows), max y (cols)
    init(rows:Int, cols:Int, filler:T) {
        
        self.cols = cols
        self.rows = rows
        matrix = Array<T>(count:cols*rows, repeatedValue:filler)
    }
    
    subscript(row:Int, col:Int) -> T {
        get
        {
            return matrix[cols * row + col]
        }
        set
        {
            matrix[cols * row + col] = newValue
        }
    }
    
    func fill(value:T)
    {
        for x in 0..<rows
        {
            for y in 0..<cols
            {
                matrix[cols*x + y] = value
            }
        }
    }
    
    func getRow(rowIndex:Int) -> [T]
    {
        var row = [T]()
        for colIndex in 0..<cols
        {
            row.append(matrix[cols*rowIndex + colIndex])
        }
        
        return row
    }
    
    func getCol(colIndex:Int) -> [T]
    {
        var col = [T]()
        for rowIndex in 0..<rows
        {
            col.append(matrix[cols*rowIndex + colIndex])
        }
        
        return col
    }
    
    func toVector() -> [T]
    {
        return matrix
    }
    
    func colCount() -> Int {
        return self.cols
    }
    
    func rowCount() -> Int {
        return self.rows
    }
}
