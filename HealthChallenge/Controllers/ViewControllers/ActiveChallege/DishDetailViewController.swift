//
//  DishViewController.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/20/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit
import Network

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
        self.dishTableView.tableFooterView = UIView()
        setSettingsButton()
        self.title = dish?.dishName

        setSettingsButton()
        monitorNetwork()
  

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        self.dishTableView.contentInsetAdjustmentBehavior = .never     
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
    

}

