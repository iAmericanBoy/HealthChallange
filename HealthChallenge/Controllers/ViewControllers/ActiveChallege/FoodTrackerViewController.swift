//
//  FoodTrackerViewController.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/18/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class FoodTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var dishDateLabel: UILabel!
    
    @IBOutlet weak var foodTrackerTableView: UITableView!
    
    var dishesKeys = {
        DishController.shared.dishes.keys.map { $0 }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.foodTrackerTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        dishDateLabel.text = Date.sharedDate.format()
        self.foodTrackerTableView.reloadData()
    }
    
    func updateViews() {
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return dishesKeys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dishesKeys[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = dishesKeys[section]
        return DishController.shared.dishes[type]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodTrackerCell", for: indexPath) as? FoodTrackerCell
        let type = dishesKeys[indexPath.section]
        
        let foodName = DishController.shared.dishes[type]?[indexPath.row].dishName
        let nutrients = DishController.shared.dishes[type]?[indexPath.row].ingredients
        
        
        cell?.dishNameLanding = foodName
        cell?.nutrientLandingPad = nutrients
        
        //print("============FoodName===========")
        //dump(foodName)
        
        return cell ?? UITableViewCell()
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let type = dishesKeys[indexPath.section]
    //        let data = DishController.shared.dishes[type]?[indexPath.row].dishName
    //        let data2 = DishController.shared.dishes[type]?[indexPath.row].ingredients
    //
    //        let data3 = DishController.shared.dishes[type]?[indexPath.row]
    //
    ////        self.performSegue(withIdentifier: "toDishVC", sender: data)
    ////
    ////        self.performSegue(withIdentifier: "toDishVC", sender: data2)
    ////
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // iidoo
        if segue.identifier == "toDishVC" {
            
            if let index = foodTrackerTableView.indexPathForSelectedRow  {
                guard let destVC = segue.destination as? DishViewController else {return}
                
                let type = dishesKeys[index.section]
                let dishToSend = DishController.shared.dishes[type]?[index.row]
                //destVC.bulletinBoard = sender as? String
                destVC.dish = dishToSend
            }
        }
        
    }
    
}


