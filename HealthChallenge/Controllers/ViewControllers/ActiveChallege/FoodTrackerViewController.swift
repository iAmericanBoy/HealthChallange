//
//  FoodTrackerViewController.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/18/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class FoodTrackerViewController: UIViewController {
    
    //MARK: - Properties
    var date: Date? {
        didSet {
            guard let date = date else {return}
            dishDateLabel.attributedText = NSAttributedString(string: date.format(), attributes: FontController.disabledButtonFont)
        }
    }
    var dateFoodEntry: FoodEntry?
    
    //MARK: - Outlets
    @IBOutlet weak var dishDateLabel: UILabel!
    @IBOutlet weak var foodTrackerTableView: UITableView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var addMealButton: UIButton!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        date = Date()
        foodTrackerTableView.delegate = self
        foodTrackerTableView.dataSource = self
        setSettingsButton()
        setupViews()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted), object: nil, queue: .main) { (notification) in
            print("Second Notification Accepted")
            self.presentAlert()
        }
        NotificationCenter.default.addObserver(forName: Notification.Name(NotificationStrings.dishesFound), object: nil, queue: .main) { (_) in
            self.foodTrackerTableView.reloadData()
        }
        foodTrackerTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted))
    }
    
    //MARK: - Actions
    @IBAction func previousDayTapped(_ sender: Any) {
        guard let dateNotNil = date else {return}
        date = Calendar.current.date(byAdding: .day, value: -1, to: dateNotNil)!
        updateViews()

    }
    
    @IBAction func nextDayTapped(_ sender: Any) {
        guard let dateNotNil = date else {return}
        date = Calendar.current.date(byAdding: .day, value: 1, to: dateNotNil)
        updateViews()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewVC" {
            if let destinationVC = segue.destination as? DishCreatorViewController {
                destinationVC.foodEntry = dateFoodEntry
            }
        } else if segue.identifier == "toDetailVC" {
            
        }
    }
    
    //MARK: - Private Functions
    func updateViews() {
        guard let dateNotNil = date else {return}
        
        if dateNotNil.stripTimestamp() == Date().stripTimestamp() {
            nextButton.isHidden = true
        } else {
            nextButton.isHidden = false
        }
        
        //Only allow food to be entered for today or yesterday
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: dateNotNil)!
        if dateNotNil.stripTimestamp() < yesterday.stripTimestamp() {
            addMealButton.isHidden = true
        } else {
            addMealButton.isHidden = false
        }
        if let entry = FoodEntryController.shared.currentEntries[dateNotNil.stripTimestamp()] {
            //display food
            dateFoodEntry = entry
            foodTrackerTableView.reloadData()
        } else {
            //create entry
            FoodEntryController.shared.createFoodEntry { (isSuccess) in
                if isSuccess {
                    if let entry = FoodEntryController.shared.currentEntries[dateNotNil.stripTimestamp()] {
                        //display food
                        self.dateFoodEntry = entry
                    }
                }
            }
        }
    }
    
    func setupViews() {
        self.navigationController?.navigationBar.titleTextAttributes = FontController.titleFont
        nextButton.setAttributedTitle(NSAttributedString(string: ">", attributes: FontController.enabledButtonFont), for: .normal)
        previousButton.setAttributedTitle(NSAttributedString(string: "<", attributes: FontController.enabledButtonFont), for: .normal)
        addMealButton.setAttributedTitle(NSAttributedString(string: "Add Meal", attributes: FontController.tableViewRowFontGREEN), for: .normal)
        dishDateLabel.attributedText = NSAttributedString(string: date!.format(), attributes: FontController.disabledButtonFont)

    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension FoodTrackerViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Breakfast"
        case 1:
            return "Snack"
        case 2:
            return "Lunch"
        case 3:
            return "Dinner"
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recordName = dateFoodEntry?.recordID.recordName else {return 0}
        switch section {
        case 0:
            let breakfastDishes = DishController.shared.dishes[recordName]?.filter({ $0.dishType == DishType.Breakfast})
            return breakfastDishes?.count ?? 0
        case 1:
            return DishController.shared.dishes[recordName]?.filter({ $0.dishType == DishType.Snack}).count ?? 0
        case 2:
            return DishController.shared.dishes[recordName]?.filter({ $0.dishType == DishType.Lunch}).count ?? 0
        case 3:
            return DishController.shared.dishes[recordName]?.filter({ $0.dishType == DishType.Dinner}).count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recordName = dateFoodEntry?.recordID.recordName else {return UITableViewCell()}
        let cell = tableView.dequeueReusableCell(withIdentifier: "dishCell", for: indexPath) as? FoodTrackerCell
        
        switch indexPath.section {
        case 0:
            cell?.dishLanding =  DishController.shared.dishes[recordName]?.filter({ $0.dishType == DishType.Breakfast})[indexPath.row]
        case 1:
            cell?.dishLanding =  DishController.shared.dishes[recordName]?.filter({ $0.dishType == DishType.Snack})[indexPath.row]
        case 2:
            cell?.dishLanding =  DishController.shared.dishes[recordName]?.filter({ $0.dishType == DishType.Lunch})[indexPath.row]
        case 3:
            cell?.dishLanding =  DishController.shared.dishes[recordName]?.filter({ $0.dishType == DishType.Dinner})[indexPath.row]
        default:
            break
        }
        return cell ?? UITableViewCell()
    }
    
    
}

//MARK: - NavigationBarSupport
extension FoodTrackerViewController {
    func setSettingsButton() {
        guard let navBar = self.navigationController?.navigationBar else { return }
        let button = UIButton()
        let image = Settings.shared.imageView
        button.addTarget(self, action: #selector(showSettingsView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        
        self.navigationController?.navigationBar.addSubview(image)
        NSLayoutConstraint.activate([
            image.rightAnchor.constraint(equalTo: navBar.rightAnchor, constant: -10),
            image.topAnchor.constraint(equalTo: navBar.topAnchor, constant: 10),
            image.heightAnchor.constraint(equalToConstant: navBar.frame.height / 2),
            image.widthAnchor.constraint(equalTo: image.heightAnchor)
            ])
        
        self.navigationController?.navigationBar.addSubview(button)
        NSLayoutConstraint.activate([
            button.rightAnchor.constraint(equalTo: navBar.rightAnchor, constant: -10),
            button.topAnchor.constraint(equalTo: navBar.topAnchor, constant: 10),
            button.heightAnchor.constraint(equalToConstant: navBar.frame.height / 2),
            button.widthAnchor.constraint(equalTo: button.heightAnchor)
            ])
        
        image.layer.cornerRadius = navBar.frame.height / 4
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
    }
    
    @objc func showSettingsView() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Settings")
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

