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
        return true
    }
    
    
    func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        
        let acceptSharing: CKAcceptSharesOperation = CKAcceptSharesOperation(shareMetadatas: [cloudKitShareMetadata])
        
        acceptSharing.qualityOfService = .userInteractive
        acceptSharing.perShareCompletionBlock = {meta, share, error in
            if let error = error {
                print("An error accepting a CKShare has occured: \(error), \(error.localizedDescription)")
            }
            
            let shareRecordName = UserDefaults.standard.string(forKey: UserDefaultStrings.ShareRecordName) ?? ""
            if share?.recordID.recordName != shareRecordName {
                let finishDate = UserDefaults.standard.value(forKey: "currentChallengeFinishDay") as? Date ?? Date(timeIntervalSince1970: 0)
                
                if finishDate.stripTimestamp() > Date().stripTimestamp() {
                    let notification = Notification(name: Notification.Name.init(NotificationStrings.secondChallengeAccepted))
                    NotificationCenter.default.post(notification)
                    guard let share = share else {return}
                    
                    CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.shareDB, recordsToUpdate: [], purchasesToDelete: [share.recordID], completion: { (isSuccess, _, _) in
                        if isSuccess {
                            print("Succesfully removed share participant")
                        }
                    })
                    
                    
                    
                } else {
                    ChallengeController.shared.currentShare = share
                    
                    CloudKitController.shared.fetchRecordZonesInTheSharedDataBase(completion: { (isSuccess, foundZones) in
                        if isSuccess {
                            foundZones?.forEach({ (zone) in
                                ChallengeController.shared.fetchCurrentChallenge(inDataBase: CloudKitController.shared.shareDB, inZoneWithID: zone.zoneID, { (isSuccess) in
                                    if isSuccess {
                                        print("Shared Challenge is now current Challenge")
                                        let challengeFound = Notification(name: Notification.Name(rawValue: NotificationStrings.challengeFound), object: nil, userInfo: nil)
                                        NotificationCenter.default.post(challengeFound)
                                        
                                        UserDefaults.standard.set(share?.recordID.recordName, forKey: UserDefaultStrings.ShareRecordName)
                                        
                                        let challengeReference = CKRecord.Reference(recordID: ChallengeController.shared.currentChallenge!.recordID, action: .none)
                                        GoalController.shared.fetchGoals(withChallengeReference: challengeReference, completion: { (isSuccess) in
                                            if isSuccess {
                                                let weekGoalsOfChallengeFound = Notification(name: Notification.Name(rawValue: NotificationStrings.weekGoalsFound), object: nil, userInfo: nil)
                                                NotificationCenter.default.post(weekGoalsOfChallengeFound)
                                            }
                                        })
                                    }
                                })
                            })
                        }
                    })
            }
            
            
            }
        }
        acceptSharing.acceptSharesCompletionBlock = { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        CKContainer(identifier: cloudKitShareMetadata.containerIdentifier).add(acceptSharing)
    }
}

