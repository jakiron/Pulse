//
//  AddPollViewController.swift
//  Pulse
//
//  Created by Jakiro on 5/9/16.
//  Copyright © 2016 jakiron. All rights reserved.
//

import UIKit
import Firebase

class AddPollViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var pollTextField: UITextField!
    @IBOutlet weak var option1TextField: UITextField!
    @IBOutlet weak var option2TextField: UITextField!
    @IBOutlet weak var option3TextField: UITextField!
    @IBOutlet weak var option4TextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var poll = Poll?()
    var currentUsername = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the current user name
        DataService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            let currentUser = snapshot.value.objectForKey("username") as! String
            
            self.currentUsername = currentUser
            }, withCancelBlock: { error in
                print(error.description)
        })
        pollTextField.delegate = self
        
        // Enable the Save button only if the text field has a valid Poll name.
        checkValidPollName()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidPollName()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        saveButton.enabled = false
    }
    
    func checkValidPollName(){
        let text = pollTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let question = pollTextField.text ?? ""
            let option1 = option1TextField.text ?? ""
            let option2 = option2TextField.text ?? ""
            let option3 = option3TextField.text ?? ""
            let option4 = option4TextField.text ?? ""
            let textOptions = [option1, option2, option3, option4]
            poll = Poll(question: question, textOptions: textOptions, votes: 0, userName: self.currentUsername)
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}