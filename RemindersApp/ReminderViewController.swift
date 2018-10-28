//
//  ReminderViewController.swift
//  RemindersApp
//
//  Created by Hemanth Kasoju on 2018-10-22.
//  Copyright © 2018 Hemanth Kasoju. All rights reserved.
//

import UIKit;
import os.log;

class ReminderViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var reminderNameText: UITextField!
    @IBOutlet weak var currentDateAndTime: UITextField!
    @IBOutlet weak var dueDateAndTime: UITextField!
    @IBOutlet weak var priorityTextField: UITextField!
    @IBOutlet weak var reminderImage: UIImageView!
    @IBOutlet weak var notesTextField: UITextField!
    
    private var datePicker: UIDatePicker?
    var priority = ["High", "Medium", "Low"];
    var picker = UIPickerView();
    var reminder : Reminder?
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }

    }
    @IBAction func chooseImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController();
        imagePickerController.delegate = self;
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet);
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action : UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else{
                print("Cannot use camera");
            }
            
            
        }));
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action : UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }));
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil));
        self.present(actionSheet, animated: true, completion: nil);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage;
        reminderImage.image = image;
        
        picker.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        // Handle the text field’s user input through delegate callbacks.
        reminderNameText.delegate = self;
        
        // Set up views if editing an existing Meal.
        if let reminder = reminder {
            navigationItem.title = reminder.title
            reminderNameText.text   = reminder.title
            reminderImage.image = reminder.photo
            priorityTextField.text = reminder.priority
            dueDateAndTime.text = reminder.dueDate
            currentDateAndTime.text = reminder.currentDate
            notesTextField.text = reminder.notes
        }
        
        printCurrentDateAndTime();
        setDateAndTime();
        showPriority();
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
         return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState();
        navigationItem.title = reminderNameText.text
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func printCurrentDateAndTime(){
        
        let formatter = DateFormatter();
        formatter.dateStyle = .long;
        formatter.timeStyle = .medium;
        let str = formatter.string(from: Date());
        currentDateAndTime.text = str;
    }
    
    
    func setDateAndTime(){
        var datePicker = UIDatePicker();
        datePicker.datePickerMode = .dateAndTime;
        datePicker.addTarget(self, action: #selector(ReminderViewController.dateChanged(datePicker:)), for: .valueChanged)
        dueDateAndTime.inputView = datePicker;
        updateSaveButtonState();

    }
    
    @objc func  dateChanged(datePicker: UIDatePicker) {
        let formatter = DateFormatter();
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ReminderViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture);
        formatter.dateStyle = .long;
        formatter.timeStyle = .medium;
        let str = formatter.string(from: datePicker.date);
        dueDateAndTime.text = str;
        view.endEditing(true);
        updateSaveButtonState();

    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true);
        updateSaveButtonState();
    }
    
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return priority.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        priorityTextField.text = priority[row];
        view.endEditing(true);
        updateSaveButtonState();

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        updateSaveButtonState();
        return priority[row];
    }
    
    func showPriority() {
        picker.delegate = self;
        picker.dataSource = self;
        priorityTextField.inputView = picker;
        view.endEditing(true);

    }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            super.prepare(for: segue, sender: sender)
            
            // Configure the destination view controller only when the save button is pressed.
            guard let button = sender as? UIBarButtonItem, button === saveButton else {
                os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
                return
            }

            let title = reminderNameText.text ?? "";
            let currentDate = currentDateAndTime.text ?? "";
            let dueDate = dueDateAndTime.text ?? "";
            let photo = reminderImage.image;
            let priority = priorityTextField.text ?? "";
            let notes = notesTextField.text ?? "";
            
           
            
            // Set the reminder to be passed to MealTableViewController after the unwind segue.
            reminder = Reminder(title : title, currentDate : currentDate, dueDate : dueDate, photo : photo, priority : priority, notes : notes)
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        saveButton.isEnabled = false;
        let reminderNametext = reminderNameText.text ?? nil
        let dueDateText = dueDateAndTime.text ?? nil
        let priorityText = priorityTextField.text ?? nil

        if !reminderNametext!.isEmpty && !dueDateText!.isEmpty && !priorityText!.isEmpty{
            saveButton.isEnabled = true;
        }
    }
    
    
}

