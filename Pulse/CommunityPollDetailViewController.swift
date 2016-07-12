//
//  CommunityPollDetailViewController.swift
//  Pulse
//
//  Created by Jakiro on 5/10/16.
//  Copyright © 2016 jakiron. All rights reserved.
//

import UIKit

class CommunityPollDetailViewController: UIViewController{
    
    var poll: Poll?
    var updatedUser: String?
    var updatedPoll: Poll?
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var optionsSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = poll!.question
        userLabel.text = "By \(poll!.userName)"
        optionsSegmentedControl.setTitle(poll!.textOptions[0], forSegmentAtIndex: 0)
        optionsSegmentedControl.setTitle(poll!.textOptions[1], forSegmentAtIndex: 1)
        optionsSegmentedControl.setTitle(poll!.textOptions[2], forSegmentAtIndex: 2)
        optionsSegmentedControl.setTitle(poll!.textOptions[3], forSegmentAtIndex: 3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if optionsSegmentedControl === sender {
            updatedUser = poll!.userName
            updatedPoll = poll
        }
    }
    
    
}