//
//  ReminderTableViewCell.swift
//  RemindersApp
//
//  Created by Hemanth Kasoju on 2018-10-26.
//  Copyright © 2018 Hemanth Kasoju. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var Priority: UILabel!
    @IBOutlet weak var reminderImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
