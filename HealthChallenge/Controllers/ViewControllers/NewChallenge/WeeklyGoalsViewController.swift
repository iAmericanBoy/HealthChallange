//
//  WeeklyGoalsViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class WeeklyGoalsViewController: UIViewController {
    
    //MARK: - Properties
    var selectedGoals: [Goal] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return GoalController.shared.allGoalsFromCK.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "User" : "Public"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GoalController.shared.allGoalsFromCK[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath)
        
        cell.textLabel?.text = GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row].name
        
        if selectedGoals.contains(GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row]) {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let goalToDelete = GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row]
            GoalController.shared.delete(goal: goalToDelete) { (isSuccess) in
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGoal = GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row]
        if selectedGoals.index(of: selectedGoal) == nil && selectedGoals.count < 4 {
            selectedGoals.append(selectedGoal)
        } else {
            guard let index = selectedGoals.index(of: selectedGoal) else {return}
            selectedGoals.remove(at: index)
        }
        
        //Animating the change
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        if selectedGoals.count == 4 {
            guard let currentChallenge = ChallengeController.shared.currentChallenge else {return}
            ChallengeController.shared.add(weeklyGoals: selectedGoals, toChallange: currentChallenge) { (isSuccess) in
                //TODO: Pop to next VC
            }
        }
    }
}

//MARK: -
extension WeeklyGoalsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
