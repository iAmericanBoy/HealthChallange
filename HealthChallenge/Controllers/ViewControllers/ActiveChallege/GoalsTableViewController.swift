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
    
    //MARK: - Properties
    var monthIntRange: [Int] = []
    var weekOne: [Int] = []
    var weekTwo: [Int] = []
    var weekThree: [Int] = []
    var weekFour: [Int] = []
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        findDateRange(from: ChallengeController.shared.currentChallenge!.startDay)
        
        weekOne = Array(monthIntRange[0...7])
        weekTwo = Array(monthIntRange[8...14])
        weekThree = Array(monthIntRange[15...21])
        weekFour = Array(monthIntRange[22...29])
    }
    
    //MARK: - Private Functions
    func findDateRange(from startDate: Date) {
        var dayRange = [startDate.day]
        var previousDate = startDate
        
        while dayRange.count != 30 {
            let date = previousDate.addingTimeInterval(86400)
            dayRange.append(date.day)
            previousDate = date
        }
        
        monthIntRange = dayRange
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
        guard let currentPoints = PointsController.shared.usersPoints else {return UITableViewCell()}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as? GoalTableViewCell
        
        cell?.goal = GoalController.shared.challengeGoals[indexPath.section][indexPath.row]

        
        switch indexPath.section {
        case 0:
            //Week
            
            switch indexPath.row {
            case 0:
                if  let index = weekOne.index(of: Date().day) {
                    cell?.dateRangeCount = Double(weekOne.count)
                    cell?.current = true
                    cell?.dateposition = Double(index)
                } else {
                    cell?.backgroundColor = currentPoints.goalOnePoints == 2 ? UIColor.purple.withAlphaComponent(0.1) : UIColor.lushGreenColor.withAlphaComponent(0.1)
                }
            case 1:
                if let index = weekTwo.index(of: Date().day) {
                    cell?.dateRangeCount = Double(weekTwo.count)
                    cell?.current = true
                    cell?.dateposition = Double(index)
                } else {
                    cell?.backgroundColor = currentPoints.goalOnePoints == 2 ? UIColor.purple.withAlphaComponent(0.1) : UIColor.lushGreenColor.withAlphaComponent(0.1)
                }
            case 2:
                if let index = weekThree.index(of: Date().day) {
                    cell?.dateRangeCount = Double(weekThree.count)
                    cell?.current = true
                    cell?.dateposition = Double(index)
                } else {
                    cell?.backgroundColor = currentPoints.goalOnePoints == 2 ? UIColor.purple.withAlphaComponent(0.1) : UIColor.lushGreenColor.withAlphaComponent(0.1)
                }
            case 3:
                if let index = weekFour.index(of: Date().day) {
                    cell?.dateRangeCount = Double(weekFour.count)
                    cell?.current = true
                    cell?.dateposition = Double(index)
                } else {
                    cell?.backgroundColor = currentPoints.goalOnePoints == 2 ? UIColor.purple.withAlphaComponent(0.1) : UIColor.lushGreenColor.withAlphaComponent(0.1)
                }
            default:
                break
            }
        case 1:
            //Month
            if  let index = monthIntRange.index(of: Date().day) {
                cell?.dateRangeCount = Double(monthIntRange.count)
                cell?.current = true
                cell?.dateposition = Double(index)
            } else {
                cell?.backgroundColor = currentPoints.goalOnePoints == 2 ? UIColor.purple.withAlphaComponent(0.1) : UIColor.lushGreenColor.withAlphaComponent(0.1)
            }
        default:
            break
        }

        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10
    }
}
