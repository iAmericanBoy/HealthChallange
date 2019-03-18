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
            guard let userID = UserController.shared.appleUserID, let challenge = ChallengeController.shared.currentChallenge else {return}
            
            GoalController.shared.fetchUsersMonthGoal(withUserReference: CKRecord.Reference(recordID: userID, action: .none), andChallengeReference: CKRecord.Reference(recordID: challenge.recordID, action: .none)) { (isSuccess) in
                if isSuccess {
                    let notification = Notification(name: Notification.Name(rawValue: NotificationStrings.monthGoalFound))
                    NotificationCenter.default.post(notification)
                }
            }
        }
        
        return true
    }
    
    
    func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        
        let acceptSharing: CKAcceptSharesOperation = CKAcceptSharesOperation(shareMetadatas: [cloudKitShareMetadata])
        
        acceptSharing.qualityOfService = .userInteractive
        acceptSharing.perShareCompletionBlock = {meta, share, error in
            print("successfully shared")
        }
        acceptSharing.acceptSharesCompletionBlock = {
            error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
        }
        CKContainer(identifier: cloudKitShareMetadata.containerIdentifier).add(acceptSharing)
    }

}

