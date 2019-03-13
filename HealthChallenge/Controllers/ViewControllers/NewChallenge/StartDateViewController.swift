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
        calendar.initializeCal()
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        previousMonthButton.isHidden = true
        monthLabel.text = "\(calendar.monthsArray[calendar.currentMonthIndex - 1]) \(calendar.currentYear)"
        NotificationCenter.default.post(name: NewChallengeParentViewController.pageSwipedNotification, object: nil, userInfo: [NewChallengeParentViewController.pageIndexKey : 0])
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.calendarCollectionView.reloadData()
        }
        monthLabel.text = "\(calendar.monthsArray[calendar.currentMonthIndex - 1]) \(calendar.currentYear)"
    }

    // MARK: - Actions
    @IBAction func previousMonthButtonTapped(_ sender: Any) {
        let monthIndex = calendar.currentMonthIndex
        let year = calendar.currentYear
        calendar.didChangeMonthDown(monthIndex: monthIndex, year: year)
        if monthIndex == calendar.currentMonthIndex {
            previousMonthButton.isHidden = true
        }
        updateViews()
    }
    
    @IBAction func nextMonthButtonTapped(_ sender: Any) {
        let monthIndex = calendar.currentMonthIndex
        let year = calendar.currentYear
        calendar.didChangeMonthUp(monthIndex: monthIndex, year: year)
        previousMonthButton.isHidden = false
        updateViews()
    }
} // end class

extension StartDateViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionItems = calendar.numOfDaysInMonth[calendar.currentMonthIndex - 1] + calendar.firstWeekDayOfMonth - 1
        return sectionItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as? DateCollectionViewCell
            else { return UICollectionViewCell() }
        let firstDay = calendar.firstWeekDayOfMonth
        let today = calendar.todaysDate
        let year = calendar.currentYear
        let month = calendar.currentMonthIndex
        cell.backgroundColor = .white
        cell.dateLabel.textColor = .black
        
        if indexPath.item <= firstDay - 2 {
            cell.isHidden = true
        } else {
            let calcDate = indexPath.row - firstDay + 2
            cell.isHidden = false
            cell.dateLabel.text = "\(calcDate)"
            if calcDate < today && year == calendar.presentYear && month == calendar.presentMonthIndex {
                cell.isUserInteractionEnabled = false
                cell.dateLabel.textColor = UIColor.lightGray
            } else {
                cell.isUserInteractionEnabled = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.green
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.white
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 7, height: 40)
    }
}
