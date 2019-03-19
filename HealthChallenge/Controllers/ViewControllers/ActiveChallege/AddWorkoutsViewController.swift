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
    var workouts: [HKWorkout] = []
    var sourceDate: Date?
    
    // MARK: - Properties
    var date: Date = Date().stripTimestamp()
    let today = Date().stripTimestamp()
    
    
    @IBOutlet weak var currentDayLabel: UILabel!
    @IBOutlet weak var previousDayButton: UIButton!
    @IBOutlet weak var nextDayButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        nextDayButton.isEnabled = false
        date = sourceDate!
        currentDayLabel.text = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
    }
    
    @IBAction func nextDayButtonTapped(_ sender: Any) {
        date.addTimeInterval(86400)
        let newWorkouts = HealthKitController.shared.readWorkoutsFrom(date: date, toDate: date)
        workouts = newWorkouts
        updateViews()
    }
    
    @IBAction func previousDayButtonTapped(_ sender: Any) {
        date.addTimeInterval(-86400)
        let newWorkouts = HealthKitController.shared.readWorkoutsFrom(date: date, toDate: date)
        workouts = newWorkouts
        updateViews()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
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
        if let numOfCalories = workout.totalEnergyBurned?.doubleValue(for: HKUnit.largeCalorie()) {
            let caloriesString = String(format: "CaloriesBurned: %.2f", numOfCalories)
            cell.textLabel?.text = caloriesString
        } else {
            cell.textLabel?.text = nil
        }
        
        return cell
    }
}
