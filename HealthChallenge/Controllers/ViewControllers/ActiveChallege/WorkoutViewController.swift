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
    var workouts: [Workout] = []
    var dateRange: [Date] = []
    
    // MARK: - MOCK DATA
    var challenge = Challenge(startDay: Date())

    // MARK: - Outlets
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var optionsButton: UIBarButtonItem!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsImage()
        calendarCollectionView.backgroundColor = .clear
        calendarController.initializeCurrentCalendar()
        findDateRange(from: Date())
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        monthLabel.text = "\(challenge.name)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        WorkoutController.shared.fetchUsersWorkouts { (success) in
            print("Fetched workouts successfully.")
            self.workouts = WorkoutController.shared.workouts
        }
    }
    
    // MARK: - Actions
    @IBAction func optionsButtonTapped(_ sender: Any) {
        
    }
    
    func settingsImage() {
        if let image = UserController.shared.loggedInUser?.photo {
            optionsButton.image = image
        } else {
            guard let image = UIImage(named: "stockPhoto"),
                let imageAsData = image.pngData()
                else { return }
            optionsButton.image = UIImage(data: imageAsData, scale: 10)
        }
    }
    
    func findDateRange(from startDate: Date) {
        var dayRange = [startDate]
        var previousDate = startDate
        let emptyCells = startDate.weekday - 1
        
        while dayRange.count != 30 {
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

// MARK: - DataSource
extension WorkoutViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateRange.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as? DateCollectionViewCell
            else { return UICollectionViewCell() }
        cell.delegate = self
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        cell.backgroundColor = .white
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.layer.cornerRadius).cgPath
        cell.isHidden = false
        
        let date = dateRange[indexPath.row]
        let today = Date()
        let monthIndex = calendarController.currentMonthIndex - 1
        var month = calendarController.shortMonthNames[monthIndex]
        
        // Set cell text label and date value.
        if date == Date().ignoreDate {
            cell.isHidden = true 
        } else {
            cell.dayLabel.text = "\(date.day)"
            cell.cellDate = dateRange[indexPath.row]
            let index = date.month
            month = calendarController.shortMonthNames[index - 1]
            cell.monthLabel.text = "\(month)"
        }
        
//        Set color of dates that show a workout.
        if !workouts.isEmpty {
            if date == workouts[indexPath.row].end {
                cell.backgroundColor = Color.theme.value
            } else {
                cell.backgroundColor = .white
            }
        }
        
        if date.stripTimestamp() == today.stripTimestamp() {
            cell.dayLabel.textColor = Color.darkText.value
            cell.monthLabel.textColor = Color.darkText.value
        }
        // Allows users to only edit workouts for past week.
        if date.day < today.day && monthIndex == calendarController.presentMonthIndex - 1{
            cell.isUserInteractionEnabled = false
        } else if date.day > today.day && monthIndex == calendarController.presentMonthIndex - 1 {
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 7) - 2, height: (collectionView.frame.width / 7) - 2)
    }
}

// Conform to DateCollectionViewCellDelegate and perform segue
extension WorkoutViewController: DateCollectionViewCellDelegate {
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton) {
        let dateCell = cell as! DateCollectionViewCell
        self.selectedDay = dateCell.cellDate!
    }
}
