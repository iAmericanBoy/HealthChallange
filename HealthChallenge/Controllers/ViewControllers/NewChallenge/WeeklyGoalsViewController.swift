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
    var challengeState = ChallengeState.noActiveChallenge
    
    // MARK: - Outlets
    @IBOutlet weak var weeklyGoalsLabel: UILabel!
    @IBOutlet weak var customGoalTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reviewForPublicSwitch: UISwitch!
    @IBOutlet weak var reviewForPublicLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        selectedGoals += GoalController.shared.weeklyGoals

        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        customGoalTextField.delegate = self
        NotificationCenter.default.post(name: NewChallengeParentViewController.pageSwipedNotification, object: nil, userInfo: [NewChallengeParentViewController.pageIndexKey : 1])
        
        NotificationCenter.default.addObserver(forName: Notification.Name(NotificationStrings.weekGoalsFound), object: nil, queue: .main) { (_) in
            self.selectedGoals += GoalController.shared.weeklyGoals
            self.updateViews()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
        let rawValue = UserDefaults.standard.value(forKey: "ChallengeState") as? Int
        challengeState = ChallengeState(rawValue: rawValue ?? 0)!
        switch ChallengeState(rawValue: rawValue ?? 0)! {
        case .isOwnerChallenge:
            updateViewsForOwner()
        case .isParticipantChallenge:
            updateViewsForParticipant()
        case .noActiveChallenge:
            updateViewsForOwner()
        }
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted), object: nil, queue: .main) { (notification) in
            print("Second Notification Accepted")
            self.presentAlert()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted))
    }
    
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let goalName = customGoalTextField.text, !goalName.isEmpty else {return}
        GoalController.shared.createGoalWith(goalName: goalName, reviewForPublic: reviewForPublicSwitch.isOn) { [weak self] (isSuccess) in
            if isSuccess {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.customGoalTextField.resignFirstResponder()
                    self?.customGoalTextField.text = ""
                    self?.reviewForPublicSwitch.isHidden = true
                    self?.reviewForPublicLabel.isHidden = true
                    self?.addButton.isHidden = true
                }
            }
        }
    }
    
    @IBAction func reviewForPublicSwitchChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: UserDefaultStrings.reviewForPublic)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let currentChallenge = ChallengeController.shared.currentChallenge else {return}
        //remove old references
        GoalController.shared.weeklyGoals.forEach { (goal) in
            GoalController.shared.remove(challenge: currentChallenge, fromGoal: goal, { (isSuccess) in
                
            })
        }
        
        selectedGoals.forEach { (goal) in
            GoalController.shared.add(newChallenge: currentChallenge, toGoal: goal, { (isSuccess) in
                
            })
        }
        // Pop to next view
    }
    
    //MARK: - Private Functions
    func updateViewsForOwner() {
        tableView.allowsSelection = true
    }
    
    func updateViewsForParticipant() {
        tableView.allowsSelection = false
        saveButton.isHidden = true
        customGoalTextField.isHidden = true
    }
    
    func updateViews() {
        reviewForPublicSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultStrings.reviewForPublic)
        
        reviewForPublicSwitch.isHidden = true
        reviewForPublicLabel.isHidden = true
        addButton.isHidden = true
        
        self.tableView.reloadData()

        
        if selectedGoals.count == 4 {
            saveButton.setTitle("save", for: .normal)
            saveButton.setTitleColor(UIColor(red: (62/255),green: (168/255),blue: (59/255),alpha: 1.0), for: .normal)
            saveButton.isEnabled = true
        } else if selectedGoals.count == 3 {
                let selectedCount = selectedGoals.count
                saveButton.setTitle("SELECT \(4 - selectedCount) GOAL", for: .normal)
                saveButton.setTitleColor(UIColor.purple, for: .normal)
                saveButton.isEnabled = false
        } else {
            let selectedCount = selectedGoals.count
            saveButton.setTitle("SELECT \(4 - selectedCount) GOALS", for: .normal)
            saveButton.setTitleColor(UIColor.purple, for: .normal)
            saveButton.isEnabled = false
        }
    }
    
} // end class


// MARK: - TableView DataSource/Delegate
extension WeeklyGoalsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch challengeState {
        case .isOwnerChallenge:
            return GoalController.shared.allGoalsFromCK.count
        case .isParticipantChallenge:
            return 1
        case .noActiveChallenge:
            return GoalController.shared.allGoalsFromCK.count
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        } else {
            return false
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch challengeState {
        case .isOwnerChallenge:
            return GoalController.shared.allGoalsFromCK[section].count
        case .isParticipantChallenge:
            return GoalController.shared.allGoalsFromCK[section].count
        case .noActiveChallenge:
            return GoalController.shared.allGoalsFromCK[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath)
        
        cell.textLabel?.text = GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row].name
        
        if selectedGoals.contains(GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row]) {
            cell.backgroundColor = UIColor(red: (62/255),green: (168/255),blue: (59/255),alpha: 0.05)
            cell.textLabel?.textColor = UIColor(red: (62/255),green: (168/255),blue: (59/255),alpha: 1.0)
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.backgroundColor = .white
            cell.textLabel?.textColor = .black
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
        
        updateViews()
        
        //Animating the change
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    
    }
}


//MARK: -
extension WeeklyGoalsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        reviewForPublicSwitch.isHidden = false
        reviewForPublicLabel.isHidden = false
        addButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            reviewForPublicSwitch.isHidden = true
            reviewForPublicLabel.isHidden = true
            addButton.isHidden = true
        }
    }
}
