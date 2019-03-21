//
//  AppStates.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/21/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation


enum UserState {
    /// User has not been created or couln't be found.
    case noUser
    /// User was found and is set in the UserController Property.
    case isUser
}

enum ChallengeState {
    /// no active Challenge
    case noActiveChallenge
    /// found a challenge that the user is the Owner off
    case isOwnerChallenge
    /// found a challenge that the user is Participating in
    case isParticipantChallenge
}

enum MonthGoalState {
    /// no month Goal yet selected
    case noMonthGoal
    /// found a month Goal for the Particular User for the current Challenge
    case isMonthGoal
}
