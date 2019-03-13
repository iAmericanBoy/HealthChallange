//
//  WeeklyGoalsViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class WeeklyGoalsViewController: UIViewController {
    
    let challengeController = ChallengeController()
    var goals: [Goal] = []
    
    // MARK: - Outlets
    @IBOutlet weak var weeklyGoalsLabel: UILabel!
    @IBOutlet weak var customGoalTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.post(name: NewChallengeParentViewController.pageSwipedNotification, object: nil, userInfo: [NewChallengeParentViewController.pageIndexKey : 1])
    }

    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
} // end class


// MARK: - TableView DataSource/Delegate
extension WeeklyGoalsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Manage number of rows
        return GoalController.shared.allPublicGoals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath)
        
        return cell
    }
}
