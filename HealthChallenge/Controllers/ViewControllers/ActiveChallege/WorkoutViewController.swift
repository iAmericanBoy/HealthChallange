//
//  WorkoutViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/14/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController {
    
    // Calendar isntance
    let calendarController = CalendarController()
    
    // Properties
    var selectedDay: Date = Date()

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var previousMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarController.initializeCurrentCalendar()
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        previousMonthButton.isHidden = true
        monthLabel.text = "\(calendarController.monthsArray[calendarController.currentMonthIndex - 1]) \(calendarController.currentYear)"
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
        let sectionItems = calendarController.numOfDaysInMonth[calendarController.currentMonthIndex - 1] + calendarController.firstWeekDayOfMonth - 1
        return sectionItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as? DateCollectionViewCell
            else { return UICollectionViewCell() }
        let firstDay = calendarController.firstWeekDayOfMonth
        let today = calendarController.todaysDate
        let year = calendarController.currentYear
        let month = calendarController.currentMonthIndex
        cell.delegate = self
        cell.layer.cornerRadius = 20
        cell.backgroundColor = .white
        cell.dateLabel.textColor = .black
        
        // Set background color for current day.
        if indexPath.item == today + 4 {
            cell.backgroundColor = .green
        }
        
        if indexPath.item <= firstDay - 2 {
            cell.isHidden = true
        } else {
            let calcDate = indexPath.row - firstDay + 2
            cell.isHidden = false
            cell.dateLabel.text = "\(calcDate)"
            let cellDate = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year: year, month: month, day: calcDate))!
            cell.cellDate = cellDate
            // Allow for edititing for one week in past.
            if calcDate < today - 6 && year == calendarController.presentYear && month == calendarController.presentMonthIndex {
                cell.isUserInteractionEnabled = false
                cell.dateLabel.textColor = UIColor.lightGray
            } else if calcDate > today && year == calendarController.presentYear && month == calendarController.presentMonthIndex {
                cell.isUserInteractionEnabled = false
                cell.dateLabel.textColor = UIColor.lightGray
            } else {
                cell.isUserInteractionEnabled = true
            }
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
        let indexPath = self.calendarCollectionView.indexPath(for: cell)
        self.selectedDay = dateCell.cellDate!
        self.performSegue(withIdentifier: "toWorkoutsVC", sender: nil)
    }
}
