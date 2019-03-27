//
//  WorkoutDetailViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/20/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit
import HealthKit

class WorkoutDetailViewController: UIViewController {

    var date = Date()
    var currentExersize = ""
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var isActive = false
    var exercises = ["Walking", "Running", "Cycling", "Eliptical", "Strength Training", "Cross Training", "Other"]
    weak var delegate: WorkoutDetailViewControllerDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var millisecondsLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var workoutPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endButton.isEnabled = false
        workoutPickerView.delegate = self
        workoutPickerView.dataSource = self
        millisecondsLabel.attributedText = NSAttributedString(string: "00", attributes: FontController.labelTitleFont)
        secondsLabel.attributedText = NSAttributedString(string: "00", attributes: FontController.labelTitleFont)
        minutesLabel.attributedText = NSAttributedString(string: "00", attributes: FontController.labelTitleFont)
        startButton.setAttributedTitle(NSAttributedString(string: "Start", attributes: FontController.enabledButtonFont), for: .normal)
        endButton.setAttributedTitle(NSAttributedString(string: "End", attributes: FontController.enabledButtonFont), for: .normal)
        finishButton.setAttributedTitle(NSAttributedString(string: "Finish Workout", attributes: FontController.enabledButtonFont), for: .normal)
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
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if isActive == true {
            return
        }
        
        startButton.isEnabled = false
        endButton.isEnabled = true
        startTime = Date().timeIntervalSinceReferenceDate - elapsed
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isActive = true
        date = Date()
    }
    
    @IBAction func endButtonTapped(_ sender: Any) {
        startButton.isEnabled = true
        endButton.isEnabled = false
        
        elapsed = Date().timeIntervalSinceReferenceDate - startTime
        timer?.invalidate()
        isActive = false
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        createWorkout()
    }
    
    @objc func updateTimer() {
        //Calc total time
        time = Date().timeIntervalSinceReferenceDate - startTime
        //Calc minutes
        let minutes = Int(time / 60)
        time -= (TimeInterval(minutes) * 60)
        //Calc seconds
        let seconds = Int(time)
        time -= TimeInterval(seconds)
        //Calc milliseconds
        let milliseconds = Int(time * 100)

        //Format time with leading zero
        let minString = String(format: "%02d", minutes)
        let secString = String(format: "%02d", seconds)
        let millString = String(format: "%02d", milliseconds)
        
        //Set labels
        minutesLabel.attributedText = NSAttributedString(string: "\(minString)", attributes: FontController.labelTitleFont)
        secondsLabel.attributedText = NSAttributedString(string: "\(secString)", attributes: FontController.labelTitleFont)
        millisecondsLabel.attributedText = NSAttributedString(string: "\(millString)", attributes: FontController.labelTitleFont)
    }
    
    func createWorkout() {
        guard let duration = TimeInterval(exactly: elapsed) else { return }
//        guard let duration = Double(durationString) else { return }
        let startDate = date
        let endDate = Date(timeInterval: duration, since: startDate)
        var activity = HKWorkoutActivityType.other
        // Edit for coreMotion
        let calories = 0.0
        let totalEnergyBurned = HKQuantity(unit: HKUnit.largeCalorie(), doubleValue: calories)
        
        // Set HKWorkoutActivityType from string value
        if currentExersize == exercises.first {
            activity = HKWorkoutActivityType.walking
        } else if currentExersize == exercises[1] {
            activity = HKWorkoutActivityType.running
        } else if currentExersize == exercises[2] {
            activity = HKWorkoutActivityType.cycling
        } else if currentExersize == exercises[3] {
            activity = HKWorkoutActivityType.elliptical
        } else if currentExersize == exercises[4] {
            activity = HKWorkoutActivityType.traditionalStrengthTraining
        } else if currentExersize == exercises[5] {
            activity = HKWorkoutActivityType.crossTraining
        } else {
            activity = HKWorkoutActivityType.other
        }
        
        if HKHealthStore.isHealthDataAvailable() {
            HealthKitController.shared.addWorkoutToHK(start: startDate, finish: endDate, activity: activity, totoalEnergyBurned: totalEnergyBurned)
            WorkoutController.shared.createWorkoutWith(startTime: startDate, endTime: endDate, duration: duration, activity: currentExersize) { (success) in
                self.delegate?.finishedWorkout(success: true)
            }
        } else {
            WorkoutController.shared.createWorkoutWith(startTime: startDate, endTime: endDate, duration: duration, activity: currentExersize) { (success) in
                self.delegate?.finishedWorkout(success: true)
            }
        }
    }
}

extension WorkoutDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // Number of columns in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // number of rows in picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exercises.count
    }
    // title for row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exercises[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentExersize = exercises[row]
    }
}

protocol WorkoutDetailViewControllerDelegate: class {
    func finishedWorkout(success: Bool)
}
