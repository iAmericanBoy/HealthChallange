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
    var ingredients: [Ingredient] = []
    
    func addDish() {
        guard let dish = dishLanding else {return}
        mealName.attributedText = NSAttributedString(string: "\(dish.dishName)", attributes: FontController.labelTitleFont)
        mealName.textColor = .purple
        
        let roundedCalories = Double(round(10*dish.totalcarbs)/10)
        let roundedSugars = Double(round(10*dish.totalsugars)/10)
        let roundedCarbs = Double(round(10*dish.totalfats)/10)
        let roundedFats = Double(round(10*dish.totalfats)/10)
        let roundedSodium = Double(round(10*dish.totalsodium)/10)
        
        caloriesLabel.attributedText = NSAttributedString(string: "Calories: \(roundedCalories) kcal", attributes: FontController.subTitleLabelFont)
        sugarsLabel.attributedText = NSAttributedString(string: "Sugar: \(roundedSugars) g", attributes: FontController.subTitleLabelFont)
        carbsLabel.attributedText = NSAttributedString(string: "Carbs: \(roundedCarbs) g", attributes: FontController.subTitleLabelFont)
        fatsLabel.attributedText = NSAttributedString(string: "Fat: \(roundedFats) g", attributes: FontController.subTitleLabelFont)
        sodiumLabel.attributedText = NSAttributedString(string: "Sodium: \(roundedSodium) mg", attributes: FontController.subTitleLabelFont)
        
    }
}


