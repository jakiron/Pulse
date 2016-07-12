//
//  Poll.swift
//  Pulse
//
//  Created by Jakiro on 5/9/16.
//  Copyright © 2016 jakiron. All rights reserved.
//

import UIKit

class Poll {
    
    //MARK: Properties
    var question: String
    var textOptions: [String]
    var votes: Int
    var userName: String
    
    //MARK: Initialization
    init?(question: String, textOptions: [String], votes: Int, userName: String){
        self.question = question
        self.textOptions = textOptions
        self.votes = votes
        self.userName = userName
        
        if question.isEmpty || textOptions.isEmpty || userName.isEmpty {
            return nil
        }
    }
    
}