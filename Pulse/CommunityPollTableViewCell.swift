//
//  CommunityPollTableViewCell.swift
//  Pulse
//
//  Created by Jakiro on 5/10/16.
//  Copyright © 2016 jakiron. All rights reserved.
//

import UIKit

class CommunityPollTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
