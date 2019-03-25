//
//  NewUserCollectionViewCell.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/24/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class NewUserCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    var userImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    var nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //MARK: - Properties
    var user: User? {
        didSet {
            self.updateViews()
        }
    }

    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        updateViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Functions
    fileprivate func updateViews() {
        guard let user = user else {return}
        userImageView.image = user.photo
        nameLabel.text = user.userName
    }
    
    fileprivate func setUpViews() {
        contentView.backgroundColor = .white
        contentView.addSubview(userImageView)
        userImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        userImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        userImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6).isActive = true
        userImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6).isActive = true

        userImageView.layer.cornerRadius = contentView.safeAreaLayoutGuide.layoutFrame.size.height * 0.3
        userImageView.layer.masksToBounds = true
        userImageView.backgroundColor = .white
        
        contentView.addSubview(nameLabel)
        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
