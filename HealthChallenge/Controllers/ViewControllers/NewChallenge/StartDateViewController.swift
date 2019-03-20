//
//  StartDateViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class StartDateViewController: UIViewController {
    
    let calendarController = CalendarController()
    var dateRange: [Date] = []
    
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
    
    //MARK: - Properties
    var challengeStartDate = ChallengeController.shared.currentChallenge?.startDay
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarController.initializeCurrentCalendar()
        findDateRange(from: Date())
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        previousMonthButton.isHidden = true
        monthLabel.text = "\(calendarController.monthsArray[calendarController.currentMonthIndex - 1]) \(calendarController.currentYear)"
        NotificationCenter.default.post(name: NewChallengeParentViewController.pageSwipedNotification, object: nil, userInfo: [NewChallengeParentViewController.pageIndexKey : 0])
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.challengeFound), object: nil, queue: nil) { [weak self] (_) in
            self?.updateViews()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    //MARK: - Private Functions
    func updateViews() {
        DispatchQueue.main.async {
            self.challengeStartDate = ChallengeController.shared.currentChallenge?.startDay
            self.calendarCollectionView.reloadData()
            self.monthLabel.text = "\(self.calendarController.monthsArray[self.calendarController.currentMonthIndex - 1]) \(self.calendarController.currentYear)"
        }
    }

    // MARK: - Actions
    @IBAction func previousMonthButtonTapped(_ sender: Any) {
        let monthIndex = calendarController.currentMonthIndex
        let year = calendarController.currentYear
        calendarController.didChangeMonthDown(monthIndex: monthIndex, year: year)
        if monthIndex == calendarController.currentMonthIndex {
            previousMonthButton.isHidden = true
        }
        updateViews()
    }
    
    @IBAction func nextMonthButtonTapped(_ sender: Any) {
        let monthIndex = calendarController.currentMonthIndex
        let year = calendarController.currentYear
        calendarController.didChangeMonthUp(monthIndex: monthIndex, year: year)
        previousMonthButton.isHidden = false
        updateViews()
    }
    
    func findDateRange(from startDate: Date) {
        var dayRange = [startDate]
        var previousDate = startDate
        let emptyCells = startDate.weekday - 1
        
        while dayRange.count != 35 {
            let date = previousDate.addingTimeInterval(86400)
            dayRange.append(date)
            previousDate = date
        }
        
        if emptyCells == 0 {
            dateRange = dayRange
        } else {
            for _ in 1...emptyCells {
                dayRange.insert(Date().ignoreDate, at: 0)
            }
        }
        dateRange = dayRange
    }
} // end class

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension StartDateViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionItems = calendarController.numOfDaysInMonth[calendarController.currentMonthIndex - 1] + calendarController.firstWeekDayOfMonth - 1
        return sectionItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as? DateCollectionViewCell
            else { return UICollectionViewCell() }
        let monthIndex = calendarController.currentMonthIndex - 1
        var month = calendarController.shortMonthNames[monthIndex]
        cell.isHidden = false
        
        let date = dateRange[indexPath.row]
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        cell.backgroundColor = .white
        cell.dayLabel.textColor = .black
        cell.cellDate = Date(timeIntervalSince1970: 0)
        
        if date == Date().ignoreDate {
            cell.isHidden = true
        } else {
            cell.dayLabel.text = "\(date.day)"
            cell.cellDate = dateRange[indexPath.row]
            let index = date.month
            month = calendarController.shortMonthNames[index - 1]
            cell.monthLabel.text = "\(month)"
        }
        
        //logic to color cells of the selected date and the 30 days in the challenge
        if let challengeStartDate = challengeStartDate {
            if cell.cellDate! == challengeStartDate {
                cell.backgroundColor = .green
            } else if cell.cellDate! <= challengeStartDate.addingTimeInterval(2592000) && cell.cellDate! >= challengeStartDate {
                cell.backgroundColor = UIColor.green.withAlphaComponent(0.1)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell else {return}
        
        cell.backgroundColor = UIColor.green
        challengeStartDate = cell.cellDate
        collectionView.reloadData()
        
        guard let date = cell.cellDate else {return}
        
        if let currentChallenge = ChallengeController.shared.currentChallenge {
            //update the date
            ChallengeController.shared.update(challenge: currentChallenge, withNewStartDate: cell.cellDate!) { (isSuccess) in
                if isSuccess {
                    // handle
                }
            }
        } else {
            // create new Challenge with date
            ChallengeController.shared.createNewChallenge(withStartDate: date) { (isSuccess) in
                if isSuccess {
                // handle
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.white
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 7) - 2, height: (collectionView.frame.width / 7) - 2)
    }
}
