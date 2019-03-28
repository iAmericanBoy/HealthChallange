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
    
    var itemLandingPad: Ingredient? {
        didSet {
            updateViews()
        }
    }
//    var nutrientLandingPad: Nutrients? {
//        didSet {
//            updateNutrients()
//        }
//    }
//
    //MARK: - CheckBox Button Image Change (Currently not being used)
    private func updateButton(isComplete: Bool) {
        let imageName = isComplete ? "complete" : "incomplete"
        checkBoxButtonTapped.setImage(UIImage(named: imageName), for: .normal)
    }
    
    func updateViews() {
        guard let unwrappedItem = itemLandingPad else {return}

        nameLabel.attributedText = NSAttributedString(string: unwrappedItem.name, attributes: FontController.tableViewRowFont)
        updateNutrients(for: unwrappedItem)
      
    }
    
    @IBAction func ingredientCheckTapped1(_ sender: Any) {
        
        print("ingredientCheckTapped1")
        delegate?.buttonCellButtontapped(self)
        
    }
    func updateNutrients(for ingredient: Ingredient) {
        
        NutrientsController.instance.getNutrients(ingredient: ingredient, completion: { (success) in
            if success {
                DispatchQueue.main.async {
                    guard let nutrientItem = ingredient.nutrients,
                        let weight = ingredient.weight,
                        let measure = ingredient.measure
                        else { return }
                    
                    self.amountLabel.attributedText = NSAttributedString(string: "\(weight) g", attributes: FontController.subTitleLabelFont)
                    self.servingSizeLabel.attributedText = NSAttributedString(string: "\(String(describing: measure))", attributes: FontController.subTitleLabelFont)
                    
                    let roundedCalories = Double(round(10 * Double(nutrientItem.calories)!)/10)
                    let roundedSugars = Double(round(10 * Double(nutrientItem.sugar)!)/10)
                    let roundedCarbs = Double(round(10 * Double(nutrientItem.carbs)!)/10)
                    let roundedFats = Double(round(10 * Double(nutrientItem.fats)!)/10)
                    let roundedSodium = Double(round(10 * Double(nutrientItem.sodium)!)/10)
                    
                    self.caloriesLabel.attributedText = NSAttributedString(string: "Calories: \(roundedCalories) cal", attributes: FontController.subTitleLabelFont)
                    self.sugarLabel.attributedText = NSAttributedString(string: "Sugar: \(roundedSugars) g", attributes: FontController.subTitleLabelFont)
                    self.carbLabel.attributedText = NSAttributedString(string: "Carbs: \(roundedCarbs) g", attributes: FontController.subTitleLabelFont)
                    self.fatLabel.attributedText = NSAttributedString(string: "Fats: \(roundedFats) g", attributes: FontController.subTitleLabelFont)
                    self.sodiumLabel.attributedText = NSAttributedString(string: "Sodium: \(roundedSodium) mg", attributes: FontController.subTitleLabelFont)
                }
            }
        })
        
        
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
