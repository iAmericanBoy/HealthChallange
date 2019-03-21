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
    //MARK: - Outlet
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    var isNoChallengeFound = false
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: CHECK if network Available
        
        _ = GoalController.shared

        fetchUser { userState in
            switch userState {
            case .isUser:
                //fetch challenge
                self.fetchChallenge({ challengeState in
                    switch challengeState {
                    case .isOwnerChallenge:
                        //check StartDate
                        //can Edit Week Goals
                        self.fetchUsersMonthGoalforActiveChallenge({ monthGoalState in
                            switch monthGoalState {
                            case .isMonthGoal: break
                            case .noMonthGoal: break
                            }
                        })
                        break
                    case .isParticipantChallenge:
                        //check StartDate
                        self.fetchUsersMonthGoalforActiveChallenge({ monthGoalState in
                            switch monthGoalState {
                            case .isMonthGoal: break
                            case .noMonthGoal: break
                            }
                        })
                    case .noActiveChallenge:
                        //can create new Challenge or join a challenge
                        //can look at past challenges
                        break
                    }
                })
            case .noUser:
                //create new User
                break
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
//        UserController.shared.fetchUserLoggedInUser { (isSuccess) in
//            if isSuccess {
//                //USER FOUND
//                print("User found")
//
//                CloudKitController.shared.fetchRecordZonesInTheSharedDataBase(completion: { (isSuccess, foundZones) in
//                    if isSuccess {
//                        foundZones?.forEach({ (zone) in
//                            ChallengeController.shared.fetchCurrentChallenge(inDataBase: CloudKitController.shared.shareDB, inZoneWithID: zone.zoneID, { (isSuccess) in
//                                if isSuccess {
//                                    print("Shared Challenge is now current Challenge")
//                                    let challengeFound = Notification(name: Notification.Name(rawValue: NotificationStrings.challengeFound), object: nil, userInfo: nil)
//                                    NotificationCenter.default.post(challengeFound)
//
//                                    let challengeReference = CKRecord.Reference(recordID: ChallengeController.shared.currentChallenge!.recordID, action: .none)
//                                    GoalController.shared.fetchGoals(withChallengeReference: challengeReference, completion: { (isSuccess) in
//                                        if isSuccess {
//                                            let weekGoalsOfChallengeFound = Notification(name: Notification.Name(rawValue: NotificationStrings.weekGoalsFound), object: nil, userInfo: nil)
//                                            NotificationCenter.default.post(weekGoalsOfChallengeFound)
//                                        }
//                                    })
//
//                                    guard let userID = UserController.shared.appleUserID else {return}
//
//                                    GoalController.shared.fetchUsersMonthGoal(withUserReference: CKRecord.Reference(recordID: userID, action: .none), andChallengeReference: challengeReference) { (isSuccess) in
//                                        if isSuccess {
//                                            //MONTHGOAL FOR USER FOUND
//                                            print("MONTHGOAL FOR USER FOUND")
//
//                                            DispatchQueue.main.async {
//                                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                                let viewController = storyboard.instantiateViewController(withIdentifier: "NewChallengeParentViewController")
//                                                self.present(viewController, animated: true, completion: nil)
//                                            }
//                                        } else {
//                                            //MONTHGOAL FOR USER NOT FOUND
//                                            print("MONTHGOAL FOR USER NOT FOUND")
//
//                                            DispatchQueue.main.async {
//                                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                                let viewController = storyboard.instantiateViewController(withIdentifier: "NewChallengeParentViewController")
//                                                self.present(viewController, animated: true, completion: nil)
//                                            }
//                                        }
//                                    }
//                                } else {
//                                    print("no Shared current Challenge found")
//                                }
//                            })
//                        })
//                    }
//                })
//                ChallengeController.shared.fetchCurrentChallenge { (isSuccess) in
//                    if isSuccess {
//                        //CURRENTCHALLENGE FOUND
//                        print("CURRENTCHALLENGE FOUND")
//                        //CHECK DATE
//                        guard let challengeID = ChallengeController.shared.currentChallenge?.recordID, let userID = UserController.shared.appleUserID else {return}
//
//                        GoalController.shared.fetchUsersMonthGoal(withUserReference: CKRecord.Reference(recordID: userID, action: .none), andChallengeReference: CKRecord.Reference(recordID: challengeID, action: .none)) { (isSuccess) in
//                            if isSuccess {
//                                //MONTHGOAL FOR USER FOUND
//                                print("MONTHGOAL FOR USER FOUND")
//
//                                DispatchQueue.main.async {
//                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                    let viewController = storyboard.instantiateViewController(withIdentifier: "NewChallengeParentViewController")
//                                    self.present(viewController, animated: true, completion: nil)
//                                }
//                            } else {
//                                //MONTHGOAL FOR USER NOT FOUND
//                                print("MONTHGOAL FOR USER NOT FOUND")
//
//                                DispatchQueue.main.async {
//                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                    let viewController = storyboard.instantiateViewController(withIdentifier: "NewChallengeParentViewController")
//                                    self.present(viewController, animated: true, completion: nil)
//                                }
//                            }
//                        }
//                    } else {
//                        //NO CHALLENGE FOUND
//                        print("NO CHALLENGE FOUND")
//
//                        DispatchQueue.main.async {
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            let viewController = storyboard.instantiateViewController(withIdentifier: "NewChallengeParentViewController")
//                            self.present(viewController, animated: true, completion: nil)
//                        }
//                    }
//                }
//            } else {
//                //USER NOT FOUND
//                print("USER NOT FOUND")
//                //Checks to see that iCloud is Available
//                if let _ = UserController.shared.appleUserID {
//                    DispatchQueue.main.async {
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let viewController = storyboard.instantiateViewController(withIdentifier: "SignUpParentViewController")
//                        self.present(viewController, animated: true, completion: nil)
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let viewController = storyboard.instantiateViewController(withIdentifier: "ActiveChallengeController")
//                        self.present(viewController, animated: true, completion: nil)
//                    }
//                }
//            }
//        }
    }
    
    
    //MARK: - Private Functions
    
    ///Fetches the User if it exists
    /// - parameter completion: Handler for when the logged in user has been found
    /// - parameter userState: The State of the User.
    func fetchUser(_ completion: @escaping (_ userState: UserState) -> Void) {
        print("Looking for User...")
        UserController.shared.fetchUserLoggedInUser { (isSuccess) in
            if isSuccess {
                print("User found")
                completion(.isUser)
            } else {
                print("No User found")
                completion(.noUser)
            }
        }
    }
    
    ///Fetches the Challenge if it exists
    /// - parameter completion: Handler for when the challenge has been found
    /// - parameter challengeState: The State of the Challenge.
    func fetchChallenge(_ completion: @escaping (_ challengeState: ChallengeState) -> Void) {
        //Look if an activeChallenge exists in the private DataBase
        print("Looking for Challenge in Private Data Base...")
        ChallengeController.shared.fetchCurrentChallenge { (isSuccess) in
            if isSuccess {
                print("Challenge found in privateDB")
                completion(.isOwnerChallenge)
            } else {
                if self.isNoChallengeFound {
                    completion(.noActiveChallenge)
                } else {
                    print("No challenge found in privateDB")
                    self.isNoChallengeFound = true
                }
            }
        }
        print("Looking for Zones in SharedDB...")
        CloudKitController.shared.fetchRecordZonesInTheSharedDataBase { (isSuccess, foundZones) in
            if isSuccess {
                print("Zones found")
                let dispachGroup = DispatchGroup()
                foundZones?.forEach({ (zone) in
                    print("Looking for Challenge in Zone...")
                    dispachGroup.enter()
                    ChallengeController.shared.fetchCurrentChallenge(inDataBase: CloudKitController.shared.shareDB, inZoneWithID: zone.zoneID, { (isSuccess) in
                        if isSuccess {
                            print("Challenge in ZoneFound")
                            completion(.isParticipantChallenge)
                        } else {
                            print("No Challenge in Zone Found")
                        }
                        dispachGroup.leave()
                    })
                })
                dispachGroup.notify(queue: .main, execute: {
                    if self.isNoChallengeFound {
                        completion(.noActiveChallenge)
                    } else {
                        print("No Zones Found")
                        self.isNoChallengeFound = true
                    }
                })
            } else {
                if self.isNoChallengeFound {
                    completion(.noActiveChallenge)
                } else {
                    print("No Zones Found")
                    self.isNoChallengeFound = true
                }
            }
        }
    }
    
    ///Fetches the User's MonthGoal if it has been set
    /// - parameter completion: Handler for when the month Goal has been found
    /// - parameter monthGoalState: The State of the MonthGoal.
    func fetchUsersMonthGoalforActiveChallenge(_ completion: @escaping (_ monthGoalState: MonthGoalState) -> Void) {
        guard let userID = UserController.shared.appleUserID, let challengeID = ChallengeController.shared.currentChallenge?.recordID else {completion(.noMonthGoal); return}
        
        print("Looking for the User's month Goal for the current Challenge...")
        GoalController.shared.fetchUsersMonthGoal(withUserReference: CKRecord.Reference(recordID: userID, action: .none), andChallengeReference: CKRecord.Reference(recordID: challengeID, action: .none)) { (isSuccess) in
            if isSuccess {
                print("Month Goal Found")
                completion(.isMonthGoal)
            } else {
                print("No Month Goal Found")
                completion(.noMonthGoal)
            }
        }
    }
}



