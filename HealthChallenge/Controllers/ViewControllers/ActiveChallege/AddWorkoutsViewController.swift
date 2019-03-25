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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let dateToSet = sourceDate else { return }
        date = dateToSet
        queryWorkouts()
        nextDayButton.isEnabled = false
        currentDayLabel.text = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted), object: nil, queue: .main) { (notification) in
            print("Second Notification Accepted")
            self.presentAlert()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted))
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
            self.currentDayLabel.text = DateFormatter.localizedString(from: self.date, dateStyle: .short, timeStyle: .none)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "workoutDetailVC" {
            let embedVC = segue.destination as? WorkoutDetailViewController
            embedVC?.delegate = self
        }
    }
}

extension AddWorkoutsViewController: WorkoutDetailViewControllerDelegate {
    func finishedWorkout(success: Bool) {
        if success == true {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
