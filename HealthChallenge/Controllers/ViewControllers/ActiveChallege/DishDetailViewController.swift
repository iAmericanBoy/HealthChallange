//
//  DishViewController.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/20/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class DishDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    @IBOutlet weak var dishTableView: UITableView!
    
    //MARK: - sending ingredient names
    var dish: Dish?
    var ingredients: [Ingredient] = [] {
        didSet{
            loadViewIfNeeded()
            self.dishTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setSettingsButton()
        self.title = dish?.dishName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         updateTotalCalories()
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted), object: nil, queue: .main) { (notification) in
            print("Second Notification Accepted")
            self.presentAlert()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted))
    }
    
    func updateTotalCalories() {
        guard let dishCal = dish?.totalcarbs else {return}
        let roundedCalories = Double(round(10 * dishCal)/10)
        totalCaloriesLabel.text = "Total Calories: \(roundedCalories) cal"
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as? DishTableViewCell
        
        cell?.ingredientLandingPad = ingredients[indexPath.row]
  
        return cell ?? UITableViewCell()
    }
    

}

