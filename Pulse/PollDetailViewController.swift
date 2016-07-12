//
//  PollDetailViewController.swift
//  Pulse
//
//  Created by Jakiro on 5/10/16.
//  Copyright © 2016 jakiron. All rights reserved.
//

import UIKit

class PollDetailViewController: UIViewController{
    
    var poll: Poll?
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = poll!.question
        userLabel.text = "By \(poll!.userName)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
