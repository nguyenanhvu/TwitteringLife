//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by Vu Nguyen on 7/22/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {


    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
