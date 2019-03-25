//
//  DateCollectionViewCell.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/23/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit


class NewDateCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    var dayLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    var monthLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //MARK: - Properties
    ///The Date associated with the cell.
    var cellDate: Date?
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Functions
    fileprivate func updateViews() {
        contentView.backgroundColor = .white
        contentView.addSubview(dayLabel)
        dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(monthLabel)
        monthLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        monthLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
