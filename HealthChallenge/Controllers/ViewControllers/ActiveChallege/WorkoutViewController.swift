//
//  WorkoutViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/14/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit
import HealthKit

class WorkoutViewController: UIViewController {
    
    // Calendar instance
    let calendarController = CalendarController()
    
    // Properties
    var selectedDay: Date = Date().stripTimestamp()
    var workouts: [HKWorkout] = []
    var dayRange: [Int] {
        let startDate = challenge.startDay
        var dayRange = [challenge.startDay.day]
        var previousDate = startDate
        let emptyCells = challenge.startDay.weekday - 1
        
        while dayRange.count != 30 {
            let date = previousDate.addingTimeInterval(86400)
            dayRange.append(date.day)
            previousDate = date
        }
        
        if emptyCells == 0 {
            return dayRange
        } else {
            for _ in 1...emptyCells {
                dayRange.insert(0, at: 0)
            }
        }
        return dayRange
    }
    
    // MARK: - MOCK DATA
    var challenge = Challenge(startDay: Date())

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var previousMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarController.initializeCurrentCalendar()
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        previousMonthButton.isHidden = true
        monthLabel.text = "\(challenge.name)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        workouts = HealthKitController.shared.readWorkoutsFrom(date: challenge.startDay, toDate: challenge.finishDay)
    }
    
    // MARK: - Actions
    @IBAction func previousMonthButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func nextMonthButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWorkoutsVC" {
            let destinationVC = segue.destination as? AddWorkoutsViewController
            let workouts = HealthKitController.shared.readWorkoutsFrom(date: selectedDay, toDate: selectedDay)
            destinationVC?.workouts = workouts
            destinationVC?.sourceDate = selectedDay
        }
    }
}

extension WorkoutViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayRange.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as? DateCollectionViewCell
            else { return UICollectionViewCell() }
        cell.delegate = self
        let day = dayRange[indexPath.row]
        let monthIndex = calendarController.currentMonthIndex - 1
        var month = calendarController.shortMonthNames[monthIndex]
        let cellDate = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year: calendarController.currentYear, month: monthIndex + 1, day: day))
        
        // Set cell text label and date value.
        if day == 0 {
            cell.dayLabel.text = ""
        } else {
            cell.dayLabel.text = "\(day)"
            // Check month value and set month short string.
            if dayRange[day] < dayRange[day + 1] {
                cell.monthLabel.text = "\(month)"
                cell.cellDate = cellDate
            } else {
                let newMonthIndex = monthIndex + 1
                month = calendarController.shortMonthNames[newMonthIndex]
                cell.monthLabel.text = "\(month)"
                cell.cellDate = cellDate
            }
        }
        // Allows users to only edit workouts for past week.
//        if indexPath.item < day - 6 && monthIndex == calendarController.presentMonthIndex {
//            cell.isUserInteractionEnabled = false
//            cell.dayLabel.textColor = UIColor.lightGray
//        } else if indexPath.item > day && monthIndex == calendarController.presentMonthIndex {
//            cell.isUserInteractionEnabled = false
//            cell.dayLabel.textColor = UIColor.lightGray
//        } else {
//            cell.isUserInteractionEnabled = true
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 7, height: 40)
    }
}

// Conform to DateCollectionViewCellDelegate and perform segue
extension WorkoutViewController: DateCollectionViewCellDelegate {
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton) {
        let dateCell = cell as! DateCollectionViewCell
        self.selectedDay = dateCell.cellDate!
    }
}
