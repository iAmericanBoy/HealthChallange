//
//  MonthGoalCollectionViewCell.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/24/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class MonthGoalCollectionViewCell: UICollectionViewCell {
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setupViews()
        updateViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Functions
    func updateViews() {
        
    }
    
    func setupViews() {
        
    }
}
