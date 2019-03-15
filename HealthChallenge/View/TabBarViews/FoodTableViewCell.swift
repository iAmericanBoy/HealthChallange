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
        amountLabel.text = unwrappedItem.measure
    }
   
    @IBAction func ingredientCheckTapped(_ sender: Any) {
        delegate?.buttonCellButtontapped(self)
        // updateButton(isComplete: true)
    }
    
    func updateNutrients() {
        guard let nutrientItem = nutrientLandingPad else { return }
        caloriesLabel.text = nutrientItem.calories
        sugarLabel.text = nutrientItem.sugar
        carbLabel.text = nutrientItem.carbs
        fatLabel.text = nutrientItem.fats
        
    }
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
