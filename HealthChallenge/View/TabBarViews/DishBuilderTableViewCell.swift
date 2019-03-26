//
//  DishBuilderTableViewCell.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/22/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class DishBuilderTableViewCell: UITableViewCell {
    
    var delegate: DishBuilderTableViewCellDelegate?
    
    var diffAmount: Double = 0.0
    
    var dishBuilderLandingPad: Food? {
        didSet {
            updateViews()
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var diffLabel: UILabel!
    @IBOutlet weak var reduceAmountButton: UIButton!
    @IBOutlet weak var addAmountButtonTaped: UIButton!
    
    @IBAction func addAmountTapped(_ sender: Any) {
        print("add Button was tapped")
        delegate?.addAmountButtonTapped(self)
    }
    
    @IBAction func reduceAmountTapped(_ sender: Any) {
        print("reduce button was tapped")
        delegate?.reduceAmountButtonTapped(self)
        
    }
    
    func updateViews() {
        guard let food = dishBuilderLandingPad else {return}
        guard let weight = food.weight else {return}
        nameLabel.attributedText = NSAttributedString(string: food.name, attributes: FontController.tableViewRowFont)
        amountLabel.attributedText = NSAttributedString(string: "\(String(describing: weight)) g", attributes: FontController.subTitleLabelFont)
        diffLabel.attributedText = NSAttributedString(string: "\(String(describing: weight)) g", attributes: FontController.subTitleLabelFont)
        
        reduceAmountButton.setAttributedTitle(NSAttributedString(string: "-", attributes: FontController.enabledButtonFont), for: .normal)
        addAmountButtonTaped.setAttributedTitle(NSAttributedString(string: "+", attributes: FontController.enabledButtonFont), for: .normal)
    }
}
protocol DishBuilderTableViewCellDelegate: class {
    func addAmountButtonTapped(_ sender: DishBuilderTableViewCell)
    func reduceAmountButtonTapped(_ sender: DishBuilderTableViewCell)
}

