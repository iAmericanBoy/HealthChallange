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
    @IBOutlet weak var reviewForPublicSwitch: UISwitch!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        customGoalTextField.delegate = self
        NotificationCenter.default.post(name: NewChallengeParentViewController.pageSwipedNotification, object: nil, userInfo: [NewChallengeParentViewController.pageIndexKey : 1])
    }

    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let goalName = customGoalTextField.text, !goalName.isEmpty else {return}
        GoalController.shared.createGoalWith(goalName: goalName, reviewForPublic: reviewForPublicSwitch.isOn) { [weak self] (isSuccess) in
            if isSuccess {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.customGoalTextField.resignFirstResponder()
                    self?.customGoalTextField.text = ""
                }
            }
        }
    }
} // end class


// MARK: - TableView DataSource/Delegate
extension WeeklyGoalsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GoalController.shared.allPublicGoals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath)
        cell.textLabel?.text = GoalController.shared.allPublicGoals[indexPath.row].name
        
        if goals.contains(GoalController.shared.allPublicGoals[indexPath.row]) {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGoal = GoalController.shared.allPublicGoals[indexPath.row]
        if goals.index(of: selectedGoal) == nil {
            goals.append(selectedGoal)
        } else {
            guard let index = goals.index(of: selectedGoal) else {return}
            goals.remove(at: index)
        }
        
        //Animating the change
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
}

//MARK: -
extension WeeklyGoalsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
