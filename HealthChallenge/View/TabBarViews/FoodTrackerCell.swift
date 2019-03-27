//
//  FoodTrackerCell.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/19/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class FoodTrackerCell: UITableViewCell {
    
    var calories: Double = 0
    var sugars: Double = 0
    var carbs: Double = 0
    var fats: Double = 0
    var sodium: Double = 0
    
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var sugarsLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var sodiumLabel: UILabel!
    
    //MARK: - dish name landing pad
    var dishLanding: Dish? {
        didSet {
            addDish()
        }
    }
    
    func addDish() {
        guard let dish = dishLanding else {return}
        mealName.text = dish.dishName
        
        let roundedCalories = Double(round(10*dish.totalcarbs)/10)
        let roundedSugars = Double(round(10*dish.totalsugars)/10)
        let roundedCarbs = Double(round(10*dish.totalfats)/10)
        let roundedFats = Double(round(10*dish.totalfats)/10)
        let roundedSodium = Double(round(10*dish.totalsodium)/10)
        
        caloriesLabel.text = "Calories: \(roundedCalories) kcal"
        sugarsLabel.text = "Sugar: \(roundedSugars) g"
        carbsLabel.text = "Carbs: \(roundedCarbs) g"
        fatsLabel.text = "Fat: \(roundedFats) g"
        sodiumLabel.text = "Sodium: \(roundedSodium) mg"
        
    }
}


