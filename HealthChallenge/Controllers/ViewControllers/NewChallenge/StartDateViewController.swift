//
//  StartDateViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class StartDateViewController: UIViewController {
    
    let calendar = CalendarController()
    
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
        previousMonthButton.isHidden = true
        NotificationCenter.default.post(name: NewChallengeParentViewController.pageSwipedNotification, object: nil, userInfo: [NewChallengeParentViewController.pageIndexKey : 0])
    }

    // MARK: - Actions
    @IBAction func previousMonthButtonTapped(_ sender: Any) {
        var index = calendar.currentMonthIndex
        index -= 1
        if index < 0 {
            index = 11
            calendar.currentYear -= 1
        }
        if index == calendar.currentMonthIndex {
            previousMonthButton.isHidden = true
        }
    }
    
    @IBAction func nextMonthButtonTapped(_ sender: Any) {
        var index = calendar.currentMonthIndex
        index += 1
        previousMonthButton.isHidden = false
        if index > 11 {
            index = 0
            calendar.currentYear += 1
        }
        monLabel.text = "\(calendar.monthsArray[index]) \(calendar.currentYear)"
    }
} // end class

