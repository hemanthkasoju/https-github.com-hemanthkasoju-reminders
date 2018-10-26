//
//  reminder.swift
//  RemindersApp
//
//  Created by Hemanth Kasoju on 2018-10-26.
//  Copyright © 2018 Hemanth Kasoju. All rights reserved.
//

import UIKit

class Reminder {
    
    var title : String;
    var currentDate : String;
    var dueDate : String;
    var photo : UIImage?;
    var priority : String;
    var notes : String;
    
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
}

