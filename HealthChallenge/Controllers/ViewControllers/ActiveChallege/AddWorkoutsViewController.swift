//
//  AddWorkoutsViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/14/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit
import HealthKit
import Network

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
        queryWorkouts()
        nextDayButton.isEnabled = false
        currentDayLabel.text = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        nextDayButton.setAttributedTitle(NSAttributedString(string: ">", attributes: FontController.enabledButtonFont), for: .normal)
        previousDayButton.setAttributedTitle(NSAttributedString(string: "<", attributes: FontController.enabledButtonFont), for: .normal)
        currentDayLabel.attributedText = NSAttributedString(string: "\(date.month)/\(date.day)", attributes: FontController.labelTitleFont)
        monitorNetwork()
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
            self.currentDayLabel.attributedText = NSAttributedString(string: "\(self.date.month)/\(self.date.day)", attributes: FontController.labelTitleFont)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "workoutDetailVC" {
            let embedVC = segue.destination as? WorkoutDetailViewController
            embedVC?.delegate = self
        }
    }
    
    //MARK: - Private Functions
    func monitorNetwork() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                self.dismissNetworkAlert()
            } else {
                print("No connection.")
                self.presentNoNetworkAlert()
            }
            
            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
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
