//
//  UserImageCollectionViewCell.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/26/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class UserImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var userImageView: UIImageView!
    
    //MARK: - Properties
    var user: User? {
        didSet {
            self.updateViews()
        }
    }
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = contentView.frame.width / 2
        userImageView.backgroundColor = .clear

        userImageView.clipsToBounds = true
     }
    
    //MARK: - Private Functions
    func updateViews() {
        guard let user = user else {return}
        userImageView.image = user.photo

        
    }
}
