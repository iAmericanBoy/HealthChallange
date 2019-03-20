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
    
    //MARK: - landing pad for nutrients that comprise a dish
    var nutrientLandingPad: [Food]? {
        didSet {
            addNutrientTotals()
        }
    }
    //MARK: - dish name landing pad
    var dishNameLanding: String? {
        didSet {
            addDishName()
        }
    }
    
    func addNutrientTotals() {
        guard let nutrients = nutrientLandingPad else { return }
        
        for nutrient in nutrients {
   
            guard let nutrientCalories = nutrient.nutrients?.calories else {return}
            guard let nutrientSugars = nutrient.nutrients?.sugar else {return}
            guard let nutrientCarbs = nutrient.nutrients?.carbs else {return}
            guard let nutrientFats = nutrient.nutrients?.fats else {return}
            guard let nutrientsSodium = nutrient.nutrients?.sodium else {return}
            
            calories += Double(nutrientCalories) ?? 0
            sugars += Double(nutrientSugars) ?? 0
            carbs += Double(nutrientCarbs) ?? 0
            fats += Double(nutrientFats) ?? 0
            sodium += Double(nutrientsSodium) ?? 0
            
            let roundedFat = Double(round(1000*fats)/1000)
            let roundedCarbs = Double(round(1000*carbs)/1000)
            let roundedSodium = Double(round(1000*sodium)/1000)
            
            caloriesLabel.text = "Calories: \(calories) kcal"
            sugarsLabel.text = "Sugar: \(sugars) g"
            carbsLabel.text = "Carbs: \(roundedCarbs) g"
            fatsLabel.text = "Fat: \(roundedFat) g"
            sodiumLabel.text = "Sodium: \(roundedSodium) mg"
            
        }
    }
    
    func addDishName() {
        guard let mealName1 = dishNameLanding else {return}
        mealName.text = mealName1
    }
}


