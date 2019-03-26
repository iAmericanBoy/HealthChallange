//
//  GoalsTableViewController.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/26/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

enum GoalType {
    case week
    case month
}
class GoalsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return GoalController.shared.challengeGoals.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GoalController.shared.challengeGoals[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Week Goals" : "Month Goal"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as? GoalTableViewCell
        
        cell?.goal = GoalController.shared.challengeGoals[indexPath.section][indexPath.row]
        cell?.current = true
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10
    }
}
