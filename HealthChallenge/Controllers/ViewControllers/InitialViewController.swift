//
//  InitialViewController.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/18/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit
import CloudKit

class InitialViewController: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: CHECK if network Available
        
        UserController.shared.fetchUserLoggedInUser { (isSuccess) in
            if isSuccess {
                //USER FOUND
                print("User found")
                
                CloudKitController.shared.fetchRecordZonesInTheSharedDataBase(completion: { (isSuccess, foundZones) in
                    if isSuccess {
                        foundZones?.forEach({ (zone) in
                            ChallengeController.shared.fetchCurrentChallenge(inDataBase: CloudKitController.shared.shareDB, inZoneWithID: zone.zoneID, { (isSuccess) in
                                if isSuccess {
                                    print("Shared Challenge is now current Challenge")
                                    let challengeFound = Notification(name: Notification.Name(rawValue: NotificationStrings.challengeFound), object: nil, userInfo: nil)
                                    NotificationCenter.default.post(challengeFound)
                                    
                                    let challengeReference = CKRecord.Reference(recordID: ChallengeController.shared.currentChallenge!.recordID, action: .none)
                                    GoalController.shared.fetchGoals(withChallengeReference: challengeReference, completion: { (isSuccess) in
                                        if isSuccess {
                                            let weekGoalsOfChallengeFound = Notification(name: Notification.Name(rawValue: NotificationStrings.weekGoalsFound), object: nil, userInfo: nil)
                                            NotificationCenter.default.post(weekGoalsOfChallengeFound)
                                        }
                                    })
                                } else {
                                    print("no Shared current Challenge found")
                                }
                            })
                        })
                    }
                })
                ChallengeController.shared.fetchCurrentChallenge { (isSuccess) in
                    if isSuccess {
                        //CURRENTCHALLENGE FOUND
                        print("CURRENTCHALLENGE FOUND")
                        //CHECK DATE
                        guard let challengeID = ChallengeController.shared.currentChallenge?.recordID, let userID = UserController.shared.appleUserID else {return}
                        
                        GoalController.shared.fetchUsersMonthGoal(withUserReference: CKRecord.Reference(recordID: userID, action: .none), andChallengeReference: CKRecord.Reference(recordID: challengeID, action: .none)) { (isSuccess) in
                            if isSuccess {
                                //MONTHGOAL FOR USER FOUND
                                print("MONTHGOAL FOR USER FOUND")

                                DispatchQueue.main.async {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let viewController = storyboard.instantiateViewController(withIdentifier: "NewChallengeParentViewController")
                                    self.present(viewController, animated: true, completion: nil)
                                }
                            } else {
                                //MONTHGOAL FOR USER NOT FOUND
                                print("MONTHGOAL FOR USER NOT FOUND")

                                DispatchQueue.main.async {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let viewController = storyboard.instantiateViewController(withIdentifier: "NewChallengeParentViewController")
                                    self.present(viewController, animated: true, completion: nil)
                                }
                            }
                        }
                    } else {
                        //NO CHALLENGE FOUND
                        print("NO CHALLENGE FOUND")

                        DispatchQueue.main.async {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let viewController = storyboard.instantiateViewController(withIdentifier: "NewChallengeParentViewController")
                            self.present(viewController, animated: true, completion: nil)
                        }
                    }
                }
            } else {
                //USER NOT FOUND
                print("USER NOT FOUND")
                //Checks to see that iCloud is Available
                if let _ = UserController.shared.appleUserID {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier: "SignUpParentViewController")
                        self.present(viewController, animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier: "ActiveChallengeController")
                        self.present(viewController, animated: true, completion: nil)
                    }
                }
            }
        }
        
        _ = GoalController.shared
    }
    
    
    //MARK: - Private Functions
    
    
}
