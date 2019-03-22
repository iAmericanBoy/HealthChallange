//
//  UserCollectionViewCell.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/22/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak var userImageView: UIImageView!
    
    //MARK: - Properties
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Private Functions
    func updateViews(){
        guard let user = user else {return}
        userImageView.image = user.photo
    }
}
