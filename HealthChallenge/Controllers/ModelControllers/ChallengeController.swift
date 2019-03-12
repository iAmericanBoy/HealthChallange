//
//  ChallengeController.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/12/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation

class ChallengeController {
    //MARK: - Singleton
    static let shared = UserController()
    
    //MARK: - CRUD
    ///Creates a new Challenge with a start date.
    /// - parameter date: The start date of the challenge.
    /// - parameter completion: Handler for when the challenge was created.
    /// - parameter isSuccess: Confirms that the challenge was created.
    func createNewChallenge(withStartDate date: Date, _ completion: @escaping (_ isSuccess: Bool) -> Void) {
        let newChallenge = Challenge(startDay: date)
        
    }
    
    func fetchCurrentChallenge() {
        
    }
    
    func update(challenge: Challenge, withNewStartDate date: Date) {
    }
    
    func add(weeklyGoals goals: [Goal], toChallange challenge: Challenge) {
        
    }
    
    func add(monthlyGoal goal: Goal, forChallenge challenge: Challenge, ofParticipent user: User) {
        
    }
    
    func delete(challenge: Challenge) {
        
    }
}
