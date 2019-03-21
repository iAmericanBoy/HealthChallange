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
    var counter = 0.0
    var timer = Timer()
    var isActive = false
    var exercises = ["Walking", "Running", "Cycling", "Eliptical", "Strength Training", "Cross Training", "Other"]
    weak var delegate: WorkoutDetailViewControllerDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var workoutPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.text = "\(counter)"
        endButton.isEnabled = false
        workoutPickerView.delegate = self
        workoutPickerView.dataSource = self
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if isActive == true {
            return
        }
        
        startButton.isEnabled = false
        endButton.isEnabled = true
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isActive = true
        date = Date()
    }
    
    @IBAction func endButtonTapped(_ sender: Any) {
        startButton.isEnabled = true
        endButton.isEnabled = false
        
        timer.invalidate()
        isActive = false
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        createWorkout()
    }
    
    @objc func updateTimer() {
        counter = counter + 0.1
        timerLabel.text = "\(counter)"
    }
    
    func createWorkout() {
        guard let durationString = timerLabel.text, durationString != "0.0" else { return }
        guard let duration = Double(durationString) else { return }
        let startDate = date
        let endDate = Date(timeInterval: duration, since: startDate)
        var activity = HKWorkoutActivityType.other
        // Edit for coreMotion
        var calories = 0.0
        var totalEnergyBurned = HKQuantity(unit: HKUnit.largeCalorie(), doubleValue: calories)
        
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
