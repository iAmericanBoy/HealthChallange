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
    
    var ingredientLandingPad: Food? {
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
        
        nameLabel.text = ingredient.name
        amountLabel.text = ingredient.measure
        caloriesLabel.text = "calories: \(calories) cal"
        sugarsLabel.text = "sugar: \(sugar) g"
        carbsLabel.text = "carbs: \(carbs) g"
        fatsLabel.text = "fats: \(fats) g"
        sodiumLabel.text = "sodium: \(sodium) mg"
    }
}


