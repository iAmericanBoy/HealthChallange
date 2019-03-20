//
//  AddWorkoutsViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/14/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit
import HealthKit

class AddWorkoutsViewController: UIViewController {
    
    // Source of truth
    var workouts: [Workout] = []
    var sourceDate: Date?
    
    // MARK: - Properties
    var date: Date = Date().stripTimestamp()
    let today = Date().stripTimestamp()
    
    
    @IBOutlet weak var addWorkoutContainer: UIView!
    @IBOutlet weak var currentDayLabel: UILabel!
    @IBOutlet weak var previousDayButton: UIButton!
    @IBOutlet weak var nextDayButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        queryWorkouts()
        nextDayButton.isEnabled = false
        date = sourceDate!
        currentDayLabel.text = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
    }
    
    // Add 24 hours to date and query workouts.
    @IBAction func nextDayButtonTapped(_ sender: Any) {
        date.addTimeInterval(86400)
        queryWorkouts()
        updateViews()
    }
    
    // Subtract 24 hours from date and query workouts.
    @IBAction func previousDayButtonTapped(_ sender: Any) {
        date.addTimeInterval(-86400)
        queryWorkouts()
        updateViews()
    }
    
    // Query workouts from HK and transform them into Workout objects.
    func queryWorkouts() {
        let newWorkouts = WorkoutController.shared.transformHKWorkoutsFrom(startDate: date, endDate: date)
        workouts = newWorkouts
    }
    
    // Enable/Disable next day button and previous day button.
    func updateViews() {
        DispatchQueue.main.async {
            if self.date == self.today {
                self.nextDayButton.isEnabled = false
            } else {
                self.nextDayButton.isEnabled = true
            }
            if self.date == self.today.addingTimeInterval(-518400) {
                self.previousDayButton.isEnabled = false
            } else {
                self.previousDayButton.isEnabled = true
            }
            self.tableView.reloadData()
            self.currentDayLabel.text = DateFormatter.localizedString(from: self.date, dateStyle: .short, timeStyle: .none)
            
            if self.workouts.isEmpty {
                self.tableView.isHidden = true
                self.addWorkoutContainer.isHidden = false
            } else {
                self.tableView.isHidden = false
                self.addWorkoutContainer.isHidden = true
            }
        }
    }
}

// MARK: - TableView DataSource
extension AddWorkoutsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath)
        let workout = workouts[indexPath.row]
        if let numOfCalories = workout.caloriesBurned {
            let caloriesString = String(format: "CaloriesBurned: %.2f", numOfCalories)
            cell.textLabel?.text = caloriesString
        } else {
            cell.textLabel?.text = nil
        }
        return cell
    }
}
