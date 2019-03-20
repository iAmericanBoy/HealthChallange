//
//  FoodTrackerViewController.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/18/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class FoodTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    @IBOutlet weak var foodTrackerTableView: UITableView!
    
    var dishesKeys = {
        DishController.shared.dishes.keys.map { $0 }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.foodTrackerTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.foodTrackerTableView.reloadData()
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
        
        print("============FoodName===========")
        //dump(foodName)
        
  
//        var calories1: Double = 0
//
//        guard let nutrients1 = nutrients else { return UITableViewCell() }
//
//        for nutrient in nutrients1 {
//            calories1 += Double((nutrient.nutrients?.calories)!)!
//
//           // cell.detailTextLabel?.text = "\(String(calories1)) calories"
//
//            print(calories1)
        
        return cell ?? UITableViewCell()
        }

//        cell.textLabel?.text = DishController.shared.dishes[type]?[indexPath.row].dishName
      //  return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


