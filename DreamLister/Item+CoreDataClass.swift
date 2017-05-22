//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Munene Kaumbutho on 2017-05-22.
//  Copyright © 2017 Munene Kaumbutho. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        // creates a date, assigns to this class whenever (an instance of this class is used)
        self.created = NSDate()
        
    }
}
