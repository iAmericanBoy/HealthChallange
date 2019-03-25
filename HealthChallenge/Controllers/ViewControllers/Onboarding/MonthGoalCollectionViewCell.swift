//
//  MonthGoalCollectionViewCell.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/24/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class MonthGoalCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    var selectedWeekGoals: [Goal] = [] {
        didSet {
            self.updateViews()
        }
    }
    
    var selectedGoal: Goal? {
        didSet {
            self.updateViews()
        }
    }
    
    var delegate: GoalsCollectionViewCellDelegate?

    
    // MARK: - Outlets
    var tableView: UITableView?
    
    fileprivate var customGoalTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Create your own Goal..."
        textField.defaultTextAttributes = FontController.textFieldFont
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var addButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Add", attributes: FontController.enabledButtonFont), for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    lazy var saveButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Save", attributes: FontController.enabledButtonFont), for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    fileprivate var reviewForPublicSwitch: UISwitch = {
        let reviewSwitch = UISwitch()
        reviewSwitch.onTintColor = UIColor.lushGreenColor
        reviewSwitch.setOn(true, animated: true)
        reviewSwitch.addTarget(self, action: #selector(reviewForPublicSwitchChanged), for: .valueChanged)
        reviewSwitch.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        reviewSwitch.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        return reviewSwitch
    }()
    
    fileprivate var reviewForPublicLabel: UILabel = {
        var label = UILabel()
        label.attributedText = NSAttributedString(string: "Allow Goal to be made public to other users of this app.", attributes: FontController.labelTitleFont)
        label.numberOfLines = 0
        label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        return label
    }()
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        customGoalTextField.delegate = self
        setupViews()
        updateViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc func addButtonTapped() {
        print("add")
        guard let name = customGoalTextField.text, !name.isEmpty else {return}
        delegate?.save(newGoalWithName: name, toReviewForPublic: reviewForPublicSwitch.isOn)
        self.tableView?.reloadData()
        self.customGoalTextField.resignFirstResponder()
        self.customGoalTextField.text = ""
        self.reviewForPublicSwitch.isHidden = true
        self.reviewForPublicLabel.isHidden = true
        self.addButton.isHidden = true
    }
    
    @objc func saveButtonTapped() {
        print("save")
        guard let goal = selectedGoal else {return}
        delegate?.save(monthGoal: goal)
        tableView?.reloadData()
    }
    
    @objc func reviewForPublicSwitchChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: UserDefaultStrings.reviewForPublic)
    }
    
    //MARK: - Private Functions
    func updateViews() {
        tableView?.reloadData()
        
        
        if selectedGoal != nil {
            saveButton.setAttributedTitle(NSAttributedString(string: "Save", attributes: FontController.enabledButtonFont), for: .normal)
            saveButton.isEnabled = true
        } else {
            saveButton.setAttributedTitle(NSAttributedString(string: "Select 1 goal", attributes: FontController.disabledButtonFont), for: .normal)
            saveButton.isEnabled = false
        }
    }
    
    func setupViews() {
        reviewForPublicSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultStrings.reviewForPublic)
        
        reviewForPublicSwitch.isHidden = true
        reviewForPublicLabel.isHidden = true
        addButton.isHidden = true
        
        let textFieldStackView = UIStackView(arrangedSubviews: [customGoalTextField,addButton])
        textFieldStackView.spacing = 10
        
        let reviewForPublicStackView = UIStackView(arrangedSubviews: [reviewForPublicLabel,reviewForPublicSwitch])
        reviewForPublicStackView.spacing = 5
        reviewForPublicStackView.distribution = .fillProportionally
        reviewForPublicStackView.alignment = .center
        
        
        let topStackView = UIStackView(arrangedSubviews: [textFieldStackView,reviewForPublicStackView,saveButton])
        topStackView.axis = .vertical
        topStackView.spacing = 5
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(topStackView)
        topStackView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        topStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        topStackView.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        
        
        tableView = UITableView()
        contentView.addSubview(tableView!)
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        tableView?.topAnchor.constraint(equalTo: topStackView.bottomAnchor).isActive = true
        tableView?.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView?.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        tableView?.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        setUpTableView()
    }
    
    func setUpTableView() {
        tableView?.tableFooterView = UIView()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tintColor = UIColor.lushGreenColor
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "goalCell")
    }
}

//MARK: - UITextFieldDelegate
extension MonthGoalCollectionViewCell: UITextFieldDelegate {
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

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MonthGoalCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return GoalController.shared.allGoalsFromCK.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GoalController.shared.allGoalsFromCK[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath)
        
        cell.selectionStyle = .none
        
        if selectedGoal == GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row] {
            cell.backgroundColor = UIColor.lushGreenColor.withAlphaComponent(0.05)
            cell.textLabel?.backgroundColor = .clear
            cell.textLabel?.attributedText = NSAttributedString(string: GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row].name, attributes: FontController.tableViewRowFontGREEN)
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else if selectedWeekGoals.contains(GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row]) {
            cell.backgroundColor = .white
            cell.textLabel?.attributedText = NSAttributedString(string: GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row].name, attributes: FontController.tableViewRowFontGRAY)
            cell.accessoryType = UITableViewCell.AccessoryType.none
        } else {
            cell.backgroundColor = .white
            cell.textLabel?.attributedText = NSAttributedString(string: GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row].name, attributes: FontController.tableViewRowFont)
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let goalToDelete = GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row]
            GoalController.shared.delete(goal: goalToDelete) { (isSuccess) in
                DispatchQueue.main.async {
                    self.tableView?.deleteRows(at: [indexPath], with: .right)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newSelectedGoal = GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row]
        if !selectedWeekGoals.contains(GoalController.shared.allGoalsFromCK[indexPath.section][indexPath.row]) {
            if selectedGoal == nil {
                selectedGoal = newSelectedGoal
            } else {
                selectedGoal = nil
            }
        }
        updateViews()
    }
}