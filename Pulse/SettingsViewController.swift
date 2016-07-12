//
//  SettingsViewController.swift
//  Pulse
//
//  Created by Jakiro on 5/10/16.
//  Copyright © 2016 jakiron. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SettingsViewController: UIViewController{
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBAction func logout(sender: AnyObject) {
        DataService.dataService.CURRENT_USER_REF.unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Login")
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the current user name
        DataService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            
                let currentUser = snapshot.value.objectForKey("username") as! String
                
                print("Username: \(currentUser)")
                self.usernameLabel.text = currentUser
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        
    }
}