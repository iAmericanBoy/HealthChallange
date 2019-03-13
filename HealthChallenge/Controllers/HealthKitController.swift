//
//  HealthKitController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/13/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitController {
    
    static let shared = HealthKitController()
    let healthStore = HKHealthStore()
    let workoutConfiguration = HKWorkoutConfiguration()
    
    // Authorization for HK use, receive auth for read/write access to Dietary Energy and Workouts.
    func authorizeHK(completion: @escaping (Bool) -> Void) {
        
        guard let caloriesConsumedType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) else { return }
        let workoutType = HKObjectType.workoutType()
        
        let writeTypes: Set<HKSampleType> = [workoutType, caloriesConsumedType]
        
        let readTypes: Set<HKObjectType> = [workoutType, caloriesConsumedType]
        
        if !HKHealthStore.isHealthDataAvailable() {
            print("HealthKit data is unavailable")
            return
        }
        
        HKHealthStore().requestAuthorization(toShare: writeTypes, read: readTypes) { (success, error) in
            if let error = error {
                print("HealthKit authorization failed : \(error.localizedDescription)")
            }
            print("Read/Write granted.")
        }
    }
    
    // Read workout information from HK and return an array of workouts.
    func readWorkoutsFrom(day: Date) -> [HKWorkout] {
        var workoutArray: [HKWorkout] = []
        let sampleType = HKObjectType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: day, end: day, options: .strictStartDate)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 0, sortDescriptors: nil) { (query, results: [HKSample]?, error) in
            var workouts: [HKWorkout] = []
            
            if let results = results {
                for result in results {
                    if let workout = result as? HKWorkout {
                        workouts.append(workout)
                    }
                }
            }
            workoutArray = workouts
        }
        healthStore.execute(query)
        return workoutArray
    }
    
    // Save food item to HK in the form of calories consumed.
    func addFoodWith(calories: Double) {
        let today = Date()
        if let type = HKSampleType.quantityType(forIdentifier: .dietaryEnergyConsumed) {
            let quantity = HKQuantity(unit: HKUnit.largeCalorie(), doubleValue: calories)
            let sample = HKQuantitySample(type: type, quantity: quantity, start: today, end: today)
            healthStore.save(sample) { (success, error) in
                if let error = error {
                    print("Error saving food to HealthKit : \(error)")
                }
                print("Food saved successfully")
            }
        }
    }
    
    // Save workout to HK with generic workout type.
    func addWorkoutToHK(start: Date, finish: Date) {
        let workout = HKWorkout(activityType: .other, start: start, end: finish)
        
        healthStore.save(workout) { (success, error) in
            if let error = error {
                print("Error saving workout to CloudKit : \(error.localizedDescription)")
            }
        }
    }
}
