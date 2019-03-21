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
        tableView.delegate = self
        tableView.dataSource = self
        nextDayButton.isEnabled = false
        date = sourceDate!
        currentDayLabel.text = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
    }
    
    // Add 24 hours to date and query workouts.
    @IBAction func nextDayButtonTapped(_ sender: Any) {
        date.addTimeInterval(86400)
        queryWorkouts()
    }
    
    // Subtract 24 hours from date and query workouts.
    @IBAction func previousDayButtonTapped(_ sender: Any) {
        date.addTimeInterval(-86400)
        queryWorkouts()
    }
    
    // Query workouts from HK and transform them into Workout objects.
    func queryWorkouts() {
        WorkoutController.shared.fetchUsersWorkouts { (success) in
            self.workouts = WorkoutController.shared.workouts
            self.updateViews()
        }
    }
    
    // Enable/Disable next day button and previous day button.
    func updateViews() {
        workouts = workouts.filter{( $0.end.stripTimestamp() == date.stripTimestamp() )}
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
                self.tableView.reloadData()
                self.addWorkoutContainer.isHidden = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "workoutDetailVC" {
            let embedVC = segue.destination as? WorkoutDetailViewController
            embedVC?.delegate = self
        }
    }
}

// MARK: - TableView DataSource
extension AddWorkoutsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as? WorkoutDetailTableViewCell
        let workout = workouts[indexPath.row]
        cell?.delegate = self
        cell?.activityLabel.text = workout.activity
        cell?.durationLabel.text = "\(workout.duration)"
        cell?.dateLabel.text = "\(workout.end.month)/\(workout.end.day)"
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let workoutToDelete = workouts[indexPath.row]
            WorkoutController.shared.delete(workout: workoutToDelete) { (success) in
                DispatchQueue.main.async {
                    self.workouts.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
}

extension AddWorkoutsViewController: WorkoutDetailViewControllerDelegate {
    func finishedWorkout(success: Bool) {
        if success == true {
            queryWorkouts()
        }
    }
}

extension AddWorkoutsViewController: WorkoutDetailTableViewCellDelegate {
}
