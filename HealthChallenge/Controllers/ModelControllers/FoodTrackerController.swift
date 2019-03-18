//
//  FoodTrackerController.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/18/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation

class FoodTrackerController {
    
    static let shared = FoodTracker()
    
    var breakfast: [[Food]] = []
    var lunch: [[Food]] = []
    var dinner: [[Food]] = []
    var snack: [[Food]] = []

    
}
