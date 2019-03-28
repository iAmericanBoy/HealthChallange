//
//  DishTableViewCell.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/20/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class DishTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var sugarsLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var sodiumLabel: UILabel!
    
    var ingredientLandingPad: Ingredient? {
        didSet {
            populateCells()
        }
    }
    
    func populateCells() {
        
        guard let ingredient = ingredientLandingPad else {return}
        guard let calories = ingredient.nutrients?.calories else {return}
        guard let sugar = ingredient.nutrients?.sugar else {return}
        guard let carbs = ingredient.nutrients?.carbs else {return}
        guard let fats = ingredient.nutrients?.fats else {return}
        guard let sodium = ingredient.nutrients?.sodium else {return}
        
        let roundedCalories = Double(round(10 * Double(calories)!)/10)
        let roundedSugars = Double(round(10 * Double(sugar)!)/10)
        let roundedCarbs = Double(round(10 * Double(carbs)!)/10)
        let roundedFats = Double(round(10 * Double(fats)!)/10)
        let roundedSodium = Double(round(10 * Double(sodium)!)/10)

        nameLabel.text = ingredient.name
        amountLabel.text = ingredient.measure
        caloriesLabel.text = "cal:\(roundedCalories) cal"
        sugarsLabel.text = "sugar: \(roundedSugars) g"
        carbsLabel.text = "carbs: \(roundedCarbs) g"
        fatsLabel.text = "fats: \(roundedFats) g"
        sodiumLabel.text = "sodium: \(roundedSodium) mg"
    }
}


