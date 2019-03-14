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
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK: - Properties
    ///The Date associated with the cell.
    var cellDate: Date?
}
