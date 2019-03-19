//
//  DateCollectionViewCell.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/12/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    
    //MARK: - Properties
    ///The Date associated with the cell.
    var cellDate: Date?
    
    // Delegate Property
    weak var delegate: DateCollectionViewCellDelegate?
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.delegate?.collectionViewCell(self, buttonTapped: button)
    }
}
// Delegate function to segue off cell selection
protocol DateCollectionViewCellDelegate: class {
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton)
}
