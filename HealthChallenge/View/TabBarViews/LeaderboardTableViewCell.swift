//
//  LeaderboardTableViewCell.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/26/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    
    func updateViews() {
        guard let user = user else { return }
        userPhoto.image = user.photo
        userPhoto.layer.cornerRadius = userPhoto.frame.width / 2
        nameLabel.attributedText = NSAttributedString(string: user.userName, attributes: FontController.labelTitleFont)
    }
}
