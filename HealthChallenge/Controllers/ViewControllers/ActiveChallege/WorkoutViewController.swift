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
    var workouts: [Workout] = [] {
        didSet{
            updateViews()
        }
    }
    var dayWorkouts: [Workout] = []
    var dateRange: [Date] = []

    // MARK: - Outlets
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var optionsButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        WorkoutController.shared.fetchUsersWorkouts { (success) in
            print("Fetched workouts successfully.")
            self.workouts = WorkoutController.shared.workouts
        }
        guard let challenge = ChallengeController.shared.currentChallenge else { return }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        settingsImage()
        calendarCollectionView.backgroundColor = .clear
        calendarController.initializeCurrentCalendar()
        findDateRange(from: Date())
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        monthLabel.text = "\(challenge.name)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateViews()
        // animations?
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
    
    func updateViews() {
        dayWorkouts = workouts.filter({ $0.end.stripTimestamp().format() == selectedDay.format() })
        DispatchQueue.main.async {
            self.calendarCollectionView.reloadData()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // only perform segue if selected day workouts is empty, and the selected day is within the past week.
        if segue.identifier == "toWorkoutsVC" && dayWorkouts.count == 0 {
            let destinationVC = segue.destination as? AddWorkoutsViewController
            destinationVC?.sourceDate = selectedDay
        }
    }
}

// MARK: - CollectionView DataSource
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
        
        if workouts.filter({ $0.end.stripTimestamp().format() == date.stripTimestamp().format() }).count > 0 {
            cell.backgroundColor = .green
        }
        
        if date.stripTimestamp() == today.stripTimestamp() {
            cell.dayLabel.textColor = Color.darkText.value
            cell.monthLabel.textColor = Color.darkText.value
        } else {
            cell.dayLabel.textColor = .black
            cell.monthLabel.textColor = .black
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

extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as? WorkoutDetailTableViewCell
        cell?.delegate = self
        let workout = dayWorkouts[indexPath.row]
        cell?.activityLabel.text = workout.activity
        cell?.durationLabel.text = "\(workout.duration)"
        cell?.dateLabel.text = "\(workout.end.month)/\(workout.end.day)"
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let workoutToDelete = dayWorkouts[indexPath.row]
            WorkoutController.shared.delete(workout: workoutToDelete) { (success) in
                DispatchQueue.main.async {
                    self.dayWorkouts.remove(at: indexPath.row)
                    self.workouts.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.updateViews()
                }
            }
        }
    }
}

// Conform to DateCollectionViewCellDelegate and perform segue
extension WorkoutViewController: DateCollectionViewCellDelegate, WorkoutDetailTableViewCellDelegate {
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton) {
        if HKHealthStore.isHealthDataAvailable() == false {
            HealthKitController.shared.authorizeHK { (success) in
                if success {
                    print("HealthKit auth granted.")
                }
            }
        }
        let dateCell = cell as! DateCollectionViewCell
        self.selectedDay = dateCell.cellDate!
        updateViews()
    }
}
