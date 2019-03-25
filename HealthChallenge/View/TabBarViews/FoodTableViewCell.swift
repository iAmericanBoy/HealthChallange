//
//  FoodTableViewCell.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/15/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
    
    weak var delegate: FoodTableViewCellDelegate?
    
    var itemLandingPad: Food? {
        didSet {
            updateViews()
        }
    }
    var nutrientLandingPad: Nutrients? {
        didSet {
            updateNutrients()
        }
    }
    //MARK: - CheckBox Button Image Change (Currently not being used)
    private func updateButton(isComplete: Bool) {
        let imageName = isComplete ? "complete" : "incomplete"
        checkBoxButtonTapped.setImage(UIImage(named: imageName), for: .normal)
    }
    
    func updateViews() {
        guard let unwrappedItem = itemLandingPad else {return}

        nameLabel.text = unwrappedItem.name
      
    }
    
    @IBAction func ingredientCheckTapped1(_ sender: Any) {
        
        print("ingredientCheckTapped1")
        delegate?.buttonCellButtontapped(self)
        
    }
    func updateNutrients() {
        
        guard let nutrientItem = nutrientLandingPad,
            let food = itemLandingPad,
            let weight = food.weight,
            let measure = food.measure
            else { return }
        
        amountLabel.text = "\(weight) g"
        servingSizeLabel.text = "\(String(describing: measure))"
        
        let roundedCalories = Double(round(10 * Double(nutrientItem.calories)!)/10)
        let roundedSugars = Double(round(10 * Double(nutrientItem.sugar)!)/10)
        let roundedCarbs = Double(round(10 * Double(nutrientItem.carbs)!)/10)
        let roundedFats = Double(round(10 * Double(nutrientItem.fats)!)/10)
        let roundedSodium = Double(round(10 * Double(nutrientItem.sodium)!)/10)
        
        
        caloriesLabel.text = "cal: \(roundedCalories) cal"
        sugarLabel.text = "sugar: \(roundedSugars) g"
        carbLabel.text = "carbs: \(roundedCarbs) g"
        fatLabel.text = "fats: \(roundedFats) g"
        sodiumLabel.text = "sodium: \(roundedSodium) mg"
    }
    
    @IBOutlet weak var servingSizeLabel: UILabel!
    @IBOutlet weak var sodiumLabel: UILabel!
    @IBOutlet weak var checkBoxButtonTapped: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!    
}

protocol FoodTableViewCellDelegate: class {
    func buttonCellButtontapped(_ sender: FoodTableViewCell)
}
