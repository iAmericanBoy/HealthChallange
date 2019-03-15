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
    var dateRange: [Date?] {
        let startDate = challenge.startDay
        var dayRange = [challenge.startDay]
        var previousDate = startDate
        let emptyCells = challenge.startDay.weekday - 1
        
        while dayRange.count != 30 {
            let date = previousDate.addingTimeInterval(86400)
            dayRange.append(date)
            previousDate = date
        }
        if emptyCells == 0 {
            return dayRange
        } else {
            for _ in 1...emptyCells {
                dayRange.insert(Date(timeIntervalSince1970: 0), at: 0)
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
        print(workouts)
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
        return dateRange.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as? DateCollectionViewCell
            else { return UICollectionViewCell() }
        cell.delegate = self
        cell.layer.cornerRadius = 20
        guard let date = dateRange[indexPath.row] else { return UICollectionViewCell() }
        let today = Date()
        let monthIndex = calendarController.currentMonthIndex - 1
        var month = calendarController.shortMonthNames[monthIndex]
        
        // Set cell text label and date value.
        if date == Date(timeIntervalSince1970: 0) {
            cell.dayLabel.text = ""
        } else {
            cell.dayLabel.text = "\(date.day)"
            cell.cellDate = dateRange[indexPath.row]
            let index = date.month
            month = calendarController.shortMonthNames[index - 1]
            cell.monthLabel.text = "\(month)"
        }
        
        if date.stripTimestamp() == today.stripTimestamp() {
            cell.backgroundColor = .green
        }
        // Allows users to only edit workouts for past week.
        if date.day < today.day && monthIndex == calendarController.presentMonthIndex - 1{
            cell.isUserInteractionEnabled = false
            cell.dayLabel.textColor = UIColor.lightGray
        } else if date.day > today.day && monthIndex == calendarController.presentMonthIndex - 1 {
            cell.isUserInteractionEnabled = false
            cell.dayLabel.textColor = UIColor.lightGray
        } else {
            cell.isUserInteractionEnabled = true
        }
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
