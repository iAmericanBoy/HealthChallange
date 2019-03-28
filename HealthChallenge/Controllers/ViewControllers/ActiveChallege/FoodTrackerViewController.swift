//
//  FoodTrackerViewController.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/18/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit
import Network

class FoodTrackerViewController: UIViewController {
    
    //MARK: - Properties
    var date: Date? {
        didSet {
            guard let date = date else {return}
            dishDateLabel.attributedText = NSAttributedString(string: date.format(), attributes: FontController.disabledButtonFont)
        }
    }
    var yesterday : Date?
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
        self.foodTrackerTableView.tableFooterView = UIView()
        date = Date()
        yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date().stripTimestamp())!

        foodTrackerTableView.delegate = self
        foodTrackerTableView.dataSource = self
        setSettingsButton()
        setupViews()
        updateViews()

        NotificationCenter.default.addObserver(self, selector: #selector(setProfileImage), name: NotificationStrings.profileImageChanged, object: nil)
    }
    
    @objc func setProfileImage() {
        let button = navigationItem.rightBarButtonItem?.customView as! UIButton
        button.setBackgroundImage(Settings.shared.imageView.image, for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.foodTrackerTableView.contentInsetAdjustmentBehavior = .never
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
            guard let index = foodTrackerTableView.indexPathForSelectedRow, let cell = foodTrackerTableView.cellForRow(at: index) as? FoodTrackerCell else {return}
            if let destinationVC = segue.destination as? DishDetailViewController {
                destinationVC.dish = cell.dishLanding
                destinationVC.ingredients = cell.ingredients
            }
        }
    }
    
    //MARK: - Private Functions
    func monitorNetwork() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                self.dismissNetworkAlert()
            } else {
                print("No connection.")
                self.presentNoNetworkAlert()
            }
            
            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func updateViews() {
        guard let dateNotNil = date else {return}
        
        if dateNotNil.stripTimestamp() == Date().stripTimestamp() {
            nextButton.isHidden = true
        } else {
            nextButton.isHidden = false
        }
        
        //Only allow food to be entered for today or yesterday
        if dateNotNil.stripTimestamp() < yesterday!.stripTimestamp() {
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
            FoodEntryController.shared.createFoodEntry(forDate: dateNotNil.stripTimestamp()) { (isSuccess) in
                if isSuccess {
                    if let entry = FoodEntryController.shared.currentEntries[dateNotNil.stripTimestamp()] {
                        //display food
                        DispatchQueue.main.async {
                            self.dateFoodEntry = entry
                            self.foodTrackerTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func setupViews() {
//        self.navigationController?.navigationBar.titleTextAttributes = FontController.titleFont
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 17, y: 13, width: tableView.frame.size.width, height: 18))
        view.backgroundColor = #colorLiteral(red: 0.9753531814, green: 0.9753531814, blue: 0.9753531814, alpha: 1)
        let label = UILabel(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: tableView.frame.size.width, height: view.frame.height))
        var text = ""
        
        if section == 0 {
            text = "Breakfast"
        } else if section == 1 {
            text = "Lunch"
        } else if section == 2 {
            text = "Dinner"
        } else if section == 3 {
            text = "Snack"
        }
        
        
        label.attributedText = NSAttributedString(string: text, attributes: FontController.labelTitleFont)
        label.textColor = UIColor.black
        view.addSubview(label)
    
       return view
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
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
            let dish = DishController.shared.dishes[recordName]?.filter({ $0.dishType == DishType.Breakfast})[indexPath.row]
            cell?.dishLanding = dish
            DishController.shared.fetchIngredients(forDish: dish!) { (_, ingredients) in
                cell?.ingredients = ingredients
            }
        case 1:
            let dish = DishController.shared.dishes[recordName]?.filter({ $0.dishType == DishType.Snack})[indexPath.row]
            cell?.dishLanding = dish
            DishController.shared.fetchIngredients(forDish: dish!) { (_, ingredients) in
                cell?.ingredients = ingredients
            }
        case 2:
            let dish = DishController.shared.dishes[recordName]?.filter({ $0.dishType == DishType.Lunch})[indexPath.row]
            cell?.dishLanding = dish
            DishController.shared.fetchIngredients(forDish: dish!) { (_, ingredients) in
                cell?.ingredients = ingredients
            }
        case 3:
            let dish = DishController.shared.dishes[recordName]?.filter({ $0.dishType == DishType.Dinner})[indexPath.row]
            cell?.dishLanding = dish
            DishController.shared.fetchIngredients(forDish: dish!) { (_, ingredients) in
                cell?.ingredients = ingredients
            }
        default:
            break
        }
        return cell ?? UITableViewCell()
    }
    
    
}

//MARK: - NavigationBarSupport
extension FoodTrackerViewController {
    
}

