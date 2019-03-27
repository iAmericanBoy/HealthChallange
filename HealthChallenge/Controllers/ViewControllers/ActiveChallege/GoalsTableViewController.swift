//
//  GoalsTableViewController.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/26/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit


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
        cell?.selectionStyle = .none
        cell?.goal = GoalController.shared.challengeGoals[indexPath.section][indexPath.row]
        
        switch indexPath.section {
        case 0:
            //Week
            switch indexPath.row {
            case 0:
                cell?.dateRangeCount = Double(weekOne.count)

                if  let index = weekOne.index(of: Date().day) {
                    //CURENTWEEK
                    cell?.dateposition = Double(index + 1)
                    if currentPoints.goalOnePoints == nil {
                        //check if points are nil if yes make points two
                        cell?.gradientColor = .lushGreenColor
                        PointsController.shared.set(weeklyGoalPoints: 2, forGoalWeek: .weekOne, toPoints: currentPoints) { (isSuccess) in
                            if isSuccess {
                                print("Points for current Week Set")
                            }
                        }
                    } else {
                        if currentPoints.goalOnePoints == 0 {
                            cell?.gradientColor = .purple
                        } else {
                            cell?.gradientColor = .lushGreenColor
                        }
                    }
                    //check if points are nil if yes make points two
                    //if points are 0 make purple
                } else {
                    //check for points
                    if currentPoints.goalOnePoints != nil {
                        if currentPoints.goalOnePoints == 2 {
                            //SUCCESSFUL GOAL
                            cell?.gradientColor = .lushGreenColor
                        } else {
                            //UNSUCCESSFUL GOAL
                            if let date = currentPoints.goalOneDate {
                                cell?.dateposition = Double(weekOne.index(of: date.day) ?? 8)
                            } else {
                                cell?.dateposition = 8
                            }
                            cell?.gradientColor = .purple
                        }
                    } else {
                        //FUTURE GOAL
                        cell?.gradientColor = .white
                    }
                }
            case 1:
                cell?.dateRangeCount = Double(weekTwo.count)
                
                if  let index = weekTwo.index(of: Date().day) {
                    cell?.dateposition = Double(index + 1)
                    if currentPoints.goalTwoPoints == nil {
                        //check if points are nil if yes make points two
                        cell?.gradientColor = .lushGreenColor
                        PointsController.shared.set(weeklyGoalPoints: 2, forGoalWeek: .weekTwo, toPoints: currentPoints) { (isSuccess) in
                            if isSuccess {
                                print("Points for current Week Set")
                            }
                        }
                    } else {
                        if currentPoints.goalTwoPoints == 0 {
                            cell?.gradientColor = .purple
                        } else {
                            cell?.gradientColor = .lushGreenColor
                        }
                    }
                } else {
                    //check for points
                    if currentPoints.goalTwoPoints != nil {
                        if currentPoints.goalTwoPoints == 2 {
                            //SUCCESSFUL GOAL
                            cell?.gradientColor = .lushGreenColor
                        } else {
                            //UNSUCCESSFUL GOAL
                            if let date = currentPoints.goalTwoDate {
                                cell?.dateposition = Double(weekTwo.index(of: date.day) ?? 7)
                            } else {
                                cell?.dateposition = 7
                            }
                            cell?.gradientColor = .purple
                        }
                    } else {
                        //FUTURE GOAL
                        cell?.gradientColor = .white
                    }
                }
            case 2:
                cell?.dateRangeCount = Double(weekThree.count)

                if let index = weekThree.index(of: Date().day) {
                    cell?.dateposition = Double(index + 1)
                    if currentPoints.goalThreePoints == nil {
                        //check if points are nil if yes make points two
                        cell?.gradientColor = .lushGreenColor
                        PointsController.shared.set(weeklyGoalPoints: 2, forGoalWeek: .weekThree, toPoints: currentPoints) { (isSuccess) in
                            if isSuccess {
                                print("Points for current Week Set")
                            }
                        }
                    } else {
                        if currentPoints.goalThreePoints == 0 {
                            cell?.gradientColor = .purple
                        } else {
                            cell?.gradientColor = .lushGreenColor
                        }
                    }
                } else {
                    //check for points
                    if currentPoints.goalThreePoints != nil {
                        if currentPoints.goalThreePoints == 2 {
                            //SUCCESSFUL GOAL
                            cell?.gradientColor = .lushGreenColor
                        } else {
                            //UNSUCCESSFUL GOAL
                            if let date = currentPoints.goalThreeDate {
                                cell?.dateposition = Double(weekThree.index(of: date.day) ?? 7)
                            } else {
                                cell?.dateposition = 7
                            }
                            cell?.gradientColor = .purple
                        }
                    } else {
                        //FUTURE GOAL
                        cell?.gradientColor = .white
                    }
                }
            case 3:
                cell?.dateRangeCount = Double(weekFour.count)

                if let index = weekFour.index(of: Date().day) {
                    cell?.dateposition = Double(index + 1)
                    if currentPoints.goalFourPoints == nil {
                        //check if points are nil if yes make points two
                        cell?.gradientColor = .lushGreenColor
                        PointsController.shared.set(weeklyGoalPoints: 2, forGoalWeek: .weekFour, toPoints: currentPoints) { (isSuccess) in
                            if isSuccess {
                                print("Points for current Week Set")
                            }
                        }
                    } else {
                        if currentPoints.goalFourPoints == 0 {
                            cell?.gradientColor = .purple
                        } else {
                            cell?.gradientColor = .lushGreenColor
                        }
                    }
                } else {
                    //check for points
                    if currentPoints.goalFourPoints != nil {
                        if currentPoints.goalFourPoints == 2 {
                            //SUCCESSFUL GOAL
                            cell?.gradientColor = .lushGreenColor
                        } else {
                            //UNSUCCESSFUL GOAL
                            if let date = currentPoints.goalFourDate {
                                cell?.dateposition = Double(weekFour.index(of: date.day) ?? 7)
                            } else {
                                cell?.dateposition = 7
                            }
                            cell?.gradientColor = .purple
                        }
                    } else {
                        //FUTURE GOAL
                        cell?.gradientColor = .white
                    }
                }
            default:
                break
            }
        case 1:
            //Month
            cell?.dateRangeCount = Double(monthIntRange.count)

            if  let index = monthIntRange.index(of: Date().day) {
                cell?.dateposition = Double(index + 1)
                if currentPoints.monthlyGoalPoints == nil {
                    //check if points are nil if yes make points two
                    cell?.gradientColor = .lushGreenColor
                    PointsController.shared.set(monthlyGoalPoints: 10, toPoints: currentPoints) { (isSuccess) in
                        if isSuccess {
                            print("Points for current Week Set")
                        }
                    }
                } else {
                    if currentPoints.monthlyGoalPoints == 0 {
                        cell?.gradientColor = .purple
                    } else {
                        cell?.gradientColor = .lushGreenColor
                    }
                }
            } else {
                //check for points
                if currentPoints.monthlyGoalPoints != nil {
                    if currentPoints.monthlyGoalPoints == 2 {
                        //SUCCESSFUL GOAL
                        cell?.gradientColor = .lushGreenColor
                    } else {
                        //UNSUCCESSFUL GOAL
                        if let date = currentPoints.monthGoalDate {
                            cell?.dateposition = Double(weekFour.index(of: date.day) ?? 7)
                        } else {
                            cell?.dateposition = 7
                        }
                        cell?.gradientColor = .purple
                    }
                } else {
                    //FUTURE GOAL
                    cell?.gradientColor = .white
                }
            }
        default:
            break
        }

        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let usersPoints = PointsController.shared.usersPoints else {return}

        
        switch indexPath.section {
        case 0:
            //Week
            switch indexPath.row {
            case 0:
                if  let index = weekOne.index(of: Date().day) {
                    if usersPoints.goalOnePoints == 0 {
                        PointsController.shared.set(weeklyGoalPoints: 2, forGoalWeek: .weekOne, toPoints: usersPoints) { (isSuccess) in
                            if isSuccess {
                                DispatchQueue.main.async {
                                    tableView.reloadRows(at: [indexPath], with: .automatic)
                                }
                            }
                        }
                    } else {
                        PointsController.shared.set(weeklyGoalPoints: 0, forGoalWeek: .weekOne, toPoints: usersPoints) { (isSuccess) in
                            if isSuccess {
                                DispatchQueue.main.async {
                                    tableView.reloadRows(at: [indexPath], with: .automatic)
                                }
                            }
                        }
                    }
                }

            case 1:
                if  let index = weekTwo.index(of: Date().day) {
                    if usersPoints.goalTwoPoints == 0 {
                        PointsController.shared.set(weeklyGoalPoints: 2, forGoalWeek: .weekTwo, toPoints: usersPoints) { (isSuccess) in
                            if isSuccess {
                                DispatchQueue.main.async {
                                    tableView.reloadRows(at: [indexPath], with: .automatic)
                                }
                            }
                        }
                    } else {
                        PointsController.shared.set(weeklyGoalPoints: 0, forGoalWeek: .weekTwo, toPoints: usersPoints) { (isSuccess) in
                            if isSuccess {
                                DispatchQueue.main.async {
                                    tableView.reloadRows(at: [indexPath], with: .automatic)
                                }
                            }
                        }
                    }
                }

   
            case 2:
                if  let index = weekThree.index(of: Date().day) {
                    if usersPoints.goalThreePoints == 0 {
                        PointsController.shared.set(weeklyGoalPoints: 2, forGoalWeek: .weekThree, toPoints: usersPoints) { (isSuccess) in
                            if isSuccess {
                                DispatchQueue.main.async {
                                    tableView.reloadRows(at: [indexPath], with: .automatic)
                                }
                            }
                        }
                    } else {
                        PointsController.shared.set(weeklyGoalPoints: 0, forGoalWeek: .weekThree, toPoints: usersPoints) { (isSuccess) in
                            if isSuccess {
                                DispatchQueue.main.async {
                                    tableView.reloadRows(at: [indexPath], with: .automatic)
                                }
                            }
                        }
                    }
                }
            case 3:
                if  let index = weekFour.index(of: Date().day) {
                    if usersPoints.goalFourPoints == 0 {
                        PointsController.shared.set(weeklyGoalPoints: 2, forGoalWeek: .weekFour, toPoints: usersPoints) { (isSuccess) in
                            if isSuccess {
                                DispatchQueue.main.async {
                                    tableView.reloadRows(at: [indexPath], with: .automatic)
                                }
                            }
                        }
                    } else {
                        PointsController.shared.set(weeklyGoalPoints: 0, forGoalWeek: .weekFour, toPoints: usersPoints) { (isSuccess) in
                            if isSuccess {
                                DispatchQueue.main.async {
                                    tableView.reloadRows(at: [indexPath], with: .automatic)
                                }
                            }
                        }
                    }
                }
            default:
                break
            }
        case 1:
            //Month
            if  let index = monthIntRange.index(of: Date().day) {
                if usersPoints.monthlyGoalPoints == 0 {
                    PointsController.shared.set(monthlyGoalPoints: 10, toPoints: usersPoints) { (isSuccess) in
                        if isSuccess {
                            DispatchQueue.main.async {
                                tableView.reloadRows(at: [indexPath], with: .automatic)
                            }
                        }
                    }
                } else {
                    PointsController.shared.set(monthlyGoalPoints: 0, toPoints: usersPoints) { (isSuccess) in
                        if isSuccess {
                            DispatchQueue.main.async {
                                tableView.reloadRows(at: [indexPath], with: .automatic)
                            }
                        }
                    }
                }
            }
        default:
            break
        }
    }
}
