//
//  StartDateViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class StartDateViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var previousMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var sunLabel: UILabel!
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var tueLabel: UILabel!
    @IBOutlet weak var wedLabel: UILabel!
    @IBOutlet weak var thuLabel: UILabel!
    @IBOutlet weak var friLabel: UILabel!
    @IBOutlet weak var satLabel: UILabel!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NewChallengeParentViewController.pageSwipedNotification, object: nil, userInfo: [NewChallengeParentViewController.pageIndexKey : 0])
    }

    // MARK: - Actions
    @IBAction func previousMonthButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func nextMonthButtonTapped(_ sender: Any) {
        
    }
} // end class
