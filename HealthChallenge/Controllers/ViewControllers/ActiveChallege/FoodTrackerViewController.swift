//
//  FoodTrackerViewController.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/18/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

// For timeStamp add 24hrs (86400 sec) to dishTimeReference VAR WHEN INCREMENT/ DECREMENT BUTTON ARE PRESSED AND GET THE
//CURRENT TIME FROM STRIPTIMESTAMP THEN FILTER ALL OF THE DISHES BY THEIR TIMESTAMP and hide next day button if we are on the current day .


import UIKit

class FoodTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var date = Date()
    var dishTimeReference: Date = Date().stripTimestamp() {
        didSet {
            dishDateLabel.attributedText = NSAttributedString(string: "\(dishTimeReference.format())", attributes: FontController.disabledButtonFont)
        }
    }
    
    @IBOutlet weak var dishDateLabel: UILabel!
    @IBOutlet weak var foodTrackerTableView: UITableView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var addMealButton: UIButton!
    
    var dishesKeys = {
        DishController.shared.dishes.keys.map { $0 }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.foodTrackerTableView.reloadData()
        setSettingsButton()
        // Sets fonts
        self.navigationController?.navigationBar.titleTextAttributes = FontController.titleFont
        nextButton.setAttributedTitle(NSAttributedString(string: ">", attributes: FontController.enabledButtonFont), for: .normal)
        previousButton.setAttributedTitle(NSAttributedString(string: "<", attributes: FontController.enabledButtonFont), for: .normal)
        addMealButton.setAttributedTitle(NSAttributedString(string: "Add Meal", attributes: FontController.tableViewRowFontGREEN), for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        dishDateLabel.attributedText = NSAttributedString(string: "\(dishTimeReference.format())", attributes: FontController.disabledButtonFont)
        self.foodTrackerTableView.reloadData()
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted), object: nil, queue: .main) { (notification) in
            print("Second Notification Accepted")
            self.presentAlert()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted))
    }
    
    @IBAction func previousDayTapped(_ sender: Any) {
        // remove 86,400 seconds from the current day variable and then filter all of the dishes by this reference
        dishTimeReference = dishTimeReference.addingTimeInterval(-86400)
        foodTrackerTableView.reloadData()
    }
    
    // remove/ hide button if we are on the current day
    @IBAction func nextDayTapped(_ sender: Any) {
        // add 86,400 seconds to current day var and then filter all of the dishes by this reference
        
        dishTimeReference = dishTimeReference.addingTimeInterval(86400)
        
        foodTrackerTableView.reloadData()
        
        
    }
    
    func updateViews() {
        //if tobenamed = today dont show next button
        //reload tableview
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return dishesKeys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dishesKeys[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = dishesKeys[section]
        
        let dishes = DishController.shared.dishes[type]!.filter({ $0.timeStamp.stripTimestamp() == dishTimeReference.stripTimestamp()})
        return dishes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodTrackerCell", for: indexPath) as? FoodTrackerCell
        let type = dishesKeys[indexPath.section]
        guard let dish = DishController.shared.dishes[type]?[indexPath.row] else { return UITableViewCell() }
        
//        let foodName = dish.dishName
//        let nutrients = dish.ingredients
        
        if dish.timeStamp.stripTimestamp() == dishTimeReference {
            cell?.dishLanding = dish
            //cell?.nutrientLandingPad = nutrients
        }
        
        //print("============FoodName===========")
        //dump(foodName)
        
        return cell ?? UITableViewCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // iidoo
        if segue.identifier == "toDishVC" {
            
            if let index = foodTrackerTableView.indexPathForSelectedRow  {
                guard let destVC = segue.destination as? DishDetailViewController else {return}
                
                let type = dishesKeys[index.section]
                let dishToSend = DishController.shared.dishes[type]?[index.row]
                //destVC.bulletinBoard = sender as? String
                destVC.dish = dishToSend
            }
        }
    }
}

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
