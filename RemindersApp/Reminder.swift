//
//  reminder.swift
//  RemindersApp
//
//  Created by Hemanth Kasoju on 2018-10-26.
//  Copyright © 2018 Hemanth Kasoju. All rights reserved.
//

import UIKit;
import os.log;


class Reminder : NSObject, NSCoding {
    
    struct PropertyKey {
        static let title = "Title";
        static let currentDate = "currentDate";
        static let dueDate = "dueDate";
        static let photo = "photo";
        static let priority = "priority";
        static let notes = "notes";
        
    }
    
    var title : String;
    var currentDate : String;
    var dueDate : String;
    var photo : UIImage?;
    var priority : String;
    var notes : String;
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("reminders")
    
    
    
    init?(title : String, currentDate : String, dueDate : String, photo : UIImage?, priority : String, notes : String ) {
        
        if title.isEmpty || dueDate.isEmpty || priority.isEmpty{
            return nil;
        }
        self.title = title;
        self.currentDate = currentDate;
        self.dueDate = dueDate;
        self.photo = photo;
        self.priority = priority;
        self.notes = notes;

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(currentDate, forKey: PropertyKey.currentDate)
        aCoder.encode(dueDate, forKey: PropertyKey.dueDate)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(priority, forKey: PropertyKey.priority)
        aCoder.encode(notes, forKey: PropertyKey.notes)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the name for a Reminder object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let dueDate = aDecoder.decodeObject(forKey: PropertyKey.dueDate) as? String else {
            os_log("Unable to decode the name for a Reminer object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let priority = aDecoder.decodeObject(forKey: PropertyKey.priority) as? String else {
            os_log("Unable to decode the name for a Reminder object.", log: OSLog.default, type: .debug)
            return nil
        }
       
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
         let currentDate = aDecoder.decodeObject(forKey: PropertyKey.currentDate) as? String
        
         let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String
        
        // Must call designated initializer.
        self.init(title : title, currentDate : currentDate ?? "nil", dueDate : dueDate, photo : photo, priority : priority, notes : notes ?? "nil")
        
        
    }
}

