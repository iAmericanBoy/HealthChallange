//
//  GoalTableViewCell.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/26/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class GoalTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var goalNameLabel: UILabel!
    @IBOutlet weak var failGoalLabel: UILabel!
    
    //MARK: - Properties
    var goal: Goal? {
        didSet {
            self.updateViews()
        }
    }
    
    var current: Bool?{
        didSet {
            self.updateViews()
        }
    }
    var month: Bool?{
        didSet {
            self.updateViews()
        }
    }
    
    var gradient =  CAGradientLayer()

    var dateRangeCount: Double? {
        didSet {
            self.updateViews()
        }
    }
    
    var dateposition: Double? {
        didSet {
            self.updateViews()
        }
    }
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        userCollectionView.delegate = self
        userCollectionView.dataSource = self
    }
    
    //MARK: - Private Functions
    func updateViews() {
        if let current = current {
            if let position = dateposition {
                if current {
                    gradient = CAGradientLayer()
                    gradient.frame = contentView.bounds
                    contentView.layer.insertSublayer(gradient, at: 0)
                    
                    gradient.locations = [0.0, NSNumber(value: (position/dateRangeCount!)) ]
                    gradient.colors = [UIColor.lushGreenColor.cgColor, UIColor.white.cgColor]
                    gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
                    gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
                    
                    
                    let gradientAnimation = CABasicAnimation(keyPath: "locations")
                    
                    gradientAnimation.fromValue = [0.0, 0.0]
                    gradientAnimation.toValue = [0.0, NSNumber(value: (position/dateRangeCount!))]
                    gradientAnimation.duration = 1.0
                    gradient.add(gradientAnimation, forKey: nil)
                    
                }
            }
        }

        guard let goal = goal else {return}
        goalNameLabel.text = goal.name
    }
}

extension GoalTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserController.shared.currentUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as? UserImageCollectionViewCell
        
        cell?.user = UserController.shared.currentUsers[indexPath.item]
        
        return cell ?? UICollectionViewCell()
    }
}
