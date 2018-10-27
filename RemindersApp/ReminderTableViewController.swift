//
//  ReminderTableViewController.swift
//  RemindersApp
//
//  Created by Hemanth Kasoju on 2018-10-26.
//  Copyright © 2018 Hemanth Kasoju. All rights reserved.
//

import UIKit
import os.log;

class ReminderTableViewController: UITableViewController {
    
    var reminders = [Reminder]();

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSampleReminders();
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "reminderTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReminderTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ReminderTableViewCell.")
        }
        
        
        let reminder = reminders[indexPath.row];
        cell.titleLabel.text = reminder.title;
        cell.dueDateLabel.text = reminder.dueDate;
        cell.Priority.text = reminder.priority;
        cell.reminderImage.image = reminder.photo;

        return cell;
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new reminder.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? ReminderViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? ReminderTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = reminders[indexPath.row]
            mealDetailViewController.reminder = selectedMeal
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    func loadSampleReminders(){
        let photo1 = UIImage(named: "defaultPhoto");
        guard let reminder1 = Reminder(title : "MC class", currentDate : "22/01/18", dueDate : "String", photo : photo1, priority : "High", notes : "Attend class") else {
            fatalError("Unable to instantiate reminder1")
        }
        
        let photo2 = UIImage(named: "defaultPhoto");
        guard let reminder2 = Reminder(title : "MC class", currentDate : "22/01/18", dueDate : "String", photo : photo2, priority : "High", notes : "Attend class") else {
            fatalError("Unable to instantiate reminder2")
        }
        
        let photo3 = UIImage(named: "defaultPhoto");
        guard let reminder3 = Reminder(title : "MC class", currentDate : "22/01/18", dueDate : "String", photo : photo3, priority : "High", notes : "Attend class") else {
            fatalError("Unable to instantiate reminder3")
        }
        
        reminders += [reminder1,reminder2, reminder3];
    }
    
    @IBAction func unwindToReminderList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ReminderViewController, let reminder = sourceViewController.reminder {
            
            // Add a new reminder.
            let newIndexPath = IndexPath(row: reminders.count, section: 0)
            
            reminders.append(reminder)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }

}
