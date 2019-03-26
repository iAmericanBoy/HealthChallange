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
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        userCollectionView.delegate = self
        userCollectionView.dataSource = self
    }
    
    //MARK: - Private Functions
    func updateViews() {
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
