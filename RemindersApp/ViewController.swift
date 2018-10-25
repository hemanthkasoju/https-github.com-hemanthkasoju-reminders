//
//  ViewController.swift
//  RemindersApp
//
//  Created by Hemanth Kasoju on 2018-10-22.
//  Copyright © 2018 Hemanth Kasoju. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var reminderNameText: UITextField!
    
    @IBOutlet weak var currentDateAndTime: UITextField!
    @IBOutlet weak var reminderName: UILabel!
    @IBOutlet weak var dueDateAndTime: UITextField!
    @IBOutlet weak var priorityTextField: UITextField!
    
  
    @IBOutlet weak var reminderImage: UIImageView!
    
    private var datePicker: UIDatePicker?
    var priority = ["High", "Medium", "Low"];
    var picker = UIPickerView();
    
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
        // Do any additional setup after loading the view, typically from a nib.
        reminderNameText.delegate = self;
        printCurrentDateAndTime();
        setDateAndTime();
        showPriority();
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
    
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return priority.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        priorityTextField.text = priority[row];
        view.endEditing(true);
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priority[row];
    }
    
    func showPriority() {
        picker.delegate = self;
        picker.dataSource = self;
        priorityTextField.inputView = picker;
        view.endEditing(true);

    }
    
    
}

