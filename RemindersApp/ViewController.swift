//
//  ViewController.swift
//  RemindersApp
//
//  Created by Hemanth Kasoju on 2018-10-22.
//  Copyright © 2018 Hemanth Kasoju. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var reminderNameText: UITextField!
    
    @IBOutlet weak var currentDateAndTime: UITextField!
    @IBOutlet weak var reminderName: UILabel!
    @IBOutlet weak var dueDateAndTime: UITextField!
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view, typically from a nib.
        reminderNameText.delegate = self;
        printCurrentDateAndTime();
        setDateAndTime();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
         return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        reminderName.text = textField.text
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
        datePicker.addTarget(self, action: #selector(ViewController.dateChanged(datePicker:)), for: .valueChanged)
        dueDateAndTime.inputView = datePicker;
        
    }
    
    @objc func  dateChanged(datePicker: UIDatePicker) {
        let formatter = DateFormatter();
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture);
        formatter.dateStyle = .long;
        formatter.timeStyle = .medium;
        let str = formatter.string(from: datePicker.date);
        dueDateAndTime.text = str;
        view.endEditing(true);
        
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true);
    }
    
    
    
}

