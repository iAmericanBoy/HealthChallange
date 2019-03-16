//
//  AppDelegate.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let dg = DispatchGroup()
        dg.enter()
        UserController.shared.fetchUserLoggedInUser { (isSuccess) in
            if isSuccess {
                dg.leave()
            }
        }
        GoalController.shared.fetchUsersGoals { (isSuccess) in
        }
        ChallengeController.shared.fetchCurrentChallenge { (isSuccess) in
            if isSuccess {
                dg.leave()
                dg.enter()
            }
        }
        
        dg.notify(queue: .main) {
            //If the user and the User and a currentChallenge exist
            guard let user = UserController.shared.loggedInUser, let challenge = ChallengeController.shared.currentChallenge else {return}
            
            GoalController.shared.fetchUsersMonthGoal(withUserReference: CKRecord.Reference(recordID: user.recordID, action: .none), andChallengeReference: CKRecord.Reference(recordID: challenge.recordID, action: .none)) { (isSuccess) in
            }
        }
        
        return true
    }

}

