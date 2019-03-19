//
//  MonthlyGoalsViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit
import CloudKit

class MonthlyGoalsViewController: UIViewController {
    
    //MARK: - Properties
    var selectedWeekGoals: [Goal] = []
    
    var seleted: Goal?
    
    // MARK: - Outlets
    @IBOutlet weak var monthGoalsLabel: UILabel!
    @IBOutlet weak var customGoalTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reviewForPublicSwitch: UISwitch!
    @IBOutlet weak var reviewForPublicLabel: UILabel!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        selectedWeekGoals += GoalController.shared.weeklyGoals
        seleted = GoalController.shared.monthGoal

        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        customGoalTextField.delegate = self
        NotificationCenter.default.post(name: NewChallengeParentViewController.pageSwipedNotification, object: nil, userInfo: [NewChallengeParentViewController.pageIndexKey : 1])
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name(NotificationStrings.weekGoalsFound), object: nil, queue: .main) { (_) in
            self.selectedWeekGoals += GoalController.shared.weeklyGoals
            self.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.monthGoalFound), object: nil, queue: .main) { (_) in
            self.seleted = GoalController.shared.monthGoal
            self.tableView.reloadData()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
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
    
    @IBAction func reviewForPublicSwitchChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: UserDefaultStrings.reviewForPublic)
    }
    
    //MARK: - Private Functions
    func updateViews() {
        reviewForPublicSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultStrings.reviewForPublic)
        
        reviewForPublicSwitch.isHidden = true
        reviewForPublicLabel.isHidden = true
    }
    
} // end class


// MARK: - TableView DataSource/Delegate
extension MonthlyGoalsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        
        if selectedWeekGoals.contains(GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row]) {
            cell.textLabel?.textColor = .gray
        }
        
        if seleted == GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row] {
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
        guard let userID = UserController.shared.appleUserID else {return}
        guard let challengeID = ChallengeController.shared.currentChallenge?.recordID else {return}
        if !selectedWeekGoals.contains(GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row]) {
            let selectedGoal = GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row]
            if seleted == nil {
                seleted = selectedGoal
                //SAVE
                GoalController.shared.add(newUserReference: CKRecord.Reference(recordID: userID, action: .none), toGoal: selectedGoal, forChallenge: CKRecord.Reference(recordID: challengeID, action: .none))  { (isSuccess) in
                }
            } else {
                //REMOVE
                seleted = nil
                GoalController.shared.remove(userRef: CKRecord.Reference(recordID: userID, action: .none), fromGoal: GoalController.shared.monthGoal!) { (isSuccess) in
                    
                }
            }
            
            //Animating the change
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
        }
    }
}


//MARK: -
extension MonthlyGoalsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        reviewForPublicSwitch.isHidden = false
        reviewForPublicLabel.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        reviewForPublicSwitch.isHidden = true
        reviewForPublicLabel.isHidden = true
    }
}
