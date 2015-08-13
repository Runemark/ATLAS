//
//  ChecklistSet.swift
//  SceneCraft
//
//  Created by Alicia Cicon on 8/6/15.
//  Copyright © 2015 Runemark. All rights reserved.
//

import Foundation

class ChecklistSet<T> : Property
{
    
    // I need this idea of "Transactions". For example
    // A checklist set MUST HAVE exactly 3 / 5 set at all times. And so, it takes a bunch of TRANSACTIONS.
        // After the first transaction, only two are set. But it doesn't get mad until all the transactions are completed
        // (so you can unset and set things without it getting mad, but once you're done setting and it still doesn't fit the requirements, it'll get mad)
    // The other option is to simply PASS exactly 3 things in at all times (set THESE THREE TO THESE THINGS), and all others are un-set
    
//    var categories:[String:T]
//    var settings:[String:Bool]
//    var maxCount:Int
//    
//    init(name:String, defaultCategories:[String], blankMember:T)
//    {
//        self.categories = [String:T]()
//        for category in defaultCategories
//        {
//            categories[category] = blankMember
//        }
//        
//        super.init(name:name)
//    }
//    
//    func addCategory(categoryName:String, value:T?)
//    {
//        categories[categoryName] = value
//    }
//    
//    func setCategory(categoryName:String, value:T?)
//    {
//        let currentCount = count()
//        if currentCount < maxCount
//        {
//            // We may set another category
//            if let _ = categories[categoryName]
//            {
//                if let _ = value
//                {
//                    
//                }
//            }
//        }
//        else
//        {
//            print("maxCount (\(maxCount)) reached: cannot set more categories")
//        }
//        
//        
//        categories[categoryName] = value
//    }
//    
//    func count() -> Int
//    {
//        var settingsCount = 0
//        
//        for (_, setting) in settings
//        {
//            if (setting)
//            {
//                settingsCount++
//            }
//        }
//        
//        return settingsCount
//    }
}