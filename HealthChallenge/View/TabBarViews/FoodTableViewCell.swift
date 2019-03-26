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

        nameLabel.attributedText = NSAttributedString(string: unwrappedItem.name, attributes: FontController.tableViewRowFont)
      
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
        
        amountLabel.attributedText = NSAttributedString(string: "\(weight) g", attributes: FontController.subTitleLabelFont)
        servingSizeLabel.attributedText = NSAttributedString(string: "\(String(describing: measure))", attributes: FontController.subTitleLabelFont)
        
        let roundedCalories = Double(round(10 * Double(nutrientItem.calories)!)/10)
        let roundedSugars = Double(round(10 * Double(nutrientItem.sugar)!)/10)
        let roundedCarbs = Double(round(10 * Double(nutrientItem.carbs)!)/10)
        let roundedFats = Double(round(10 * Double(nutrientItem.fats)!)/10)
        let roundedSodium = Double(round(10 * Double(nutrientItem.sodium)!)/10)
        
        caloriesLabel.attributedText = NSAttributedString(string: "Calories: \(roundedCalories) cal", attributes: FontController.subTitleLabelFont)
        sugarLabel.attributedText = NSAttributedString(string: "Sugar: \(roundedSugars) g", attributes: FontController.subTitleLabelFont)
        carbLabel.attributedText = NSAttributedString(string: "Carbs: \(roundedCarbs) g", attributes: FontController.subTitleLabelFont)
        fatLabel.attributedText = NSAttributedString(string: "Fats: \(roundedFats) g", attributes: FontController.subTitleLabelFont)
        sodiumLabel.attributedText = NSAttributedString(string: "Sodium: \(roundedSodium) g", attributes: FontController.subTitleLabelFont)
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
