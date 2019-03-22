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
        
        //fetch User
        fetchUser { userState in
            switch userState {
            case .isUser:
                UserDefaults.standard.set(UserState.isUser.hashValue, forKey: "UserState")
                //fetch challenge
                self.fetchChallenge({ challengeState in
                    switch challengeState {
                    case .isOwnerChallenge:
                        UserDefaults.standard.set(ChallengeState.isOwnerChallenge.rawValue, forKey: "ChallengeState")
                        let finishDay = ChallengeController.shared.currentChallenge?.finishDay

                        UserDefaults.standard.set(finishDay, forKey: "currentChallengeFinishDay")

                        let challengeFound = Notification(name: Notification.Name(rawValue: NotificationStrings.challengeFound), object: nil, userInfo: nil)
                        NotificationCenter.default.post(challengeFound)
                        
                        self.fetchWeekGoalsForCurrentChallenge()

                        //can Edit Week Goals
                        self.fetchUsersMonthGoalforActiveChallenge({ monthGoalState in
                            switch monthGoalState {
                            case .isMonthGoal:
                                //check StartDate
                                print("Checking for Start Day...")
                                let startDay = ChallengeController.shared.currentChallenge?.startDay
                                
                                if startDay! > Date() {
                                    //before StartDay
                                    print("Challenge's StartDay before Today")
                                    print("Current Challenge's StartDay:\(startDay!)")
                                    self.currentChallenge()
                                } else {
                                    //after startDay
                                    print("Challenge's StartDay after Today")
                                    print("Current Challenge's StartDay:\(startDay!)")
                                    self.activeChallenge()
                                }
                                
                                
                            case .noMonthGoal:
                                self.addMonthGoal()
                            }
                        })
                        break
                    case .isParticipantChallenge:
                        UserDefaults.standard.set(ChallengeState.isParticipantChallenge.rawValue, forKey: "ChallengeState")
                        let finishDay = ChallengeController.shared.currentChallenge?.finishDay
                        
                        UserDefaults.standard.set(finishDay, forKey: "currentChallengeFinishDay")
                        
                        let challengeFound = Notification(name: Notification.Name(rawValue: NotificationStrings.challengeFound), object: nil, userInfo: nil)
                        NotificationCenter.default.post(challengeFound)
                        
                        self.fetchWeekGoalsForCurrentChallenge()
                        
                        //check StartDate
                        self.fetchUsersMonthGoalforActiveChallenge({ monthGoalState in
                            switch monthGoalState {
                            case .isMonthGoal:
                                print("Checking for Start Day...")
                                let startDay = ChallengeController.shared.currentChallenge?.startDay
                                
                                if startDay! < Date() {
                                    //before StartDay
                                    print("Challenge's StartDay after Today")
                                    print("Current Challenge's StartDay:\(startDay!)")
                                    self.currentChallenge()
                                } else {
                                    //after startDay
                                    print("Challenge's StartDay after Today")
                                    print("Current Challenge's StartDay:\(startDay!)")
                                    self.activeChallenge()
                                }
                            case .noMonthGoal:
                                self.addMonthGoal()
                            }
                        })
                    case .noActiveChallenge:
                        //can create new Challenge or join a challenge
                        //can look at past challenges
                        UserDefaults.standard.set(nil, forKey: "currentChallengeFinishDay")

                        self.createNewChallenge()
                        
                    }
                })
            case .noUser:
                UserDefaults.standard.set(UserState.noUser.hashValue, forKey: "UserState")

                //create new User
                self.createNewUser()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted), object: nil, queue: .main) { (notification) in
            print("Second Notification Accepted")
            self.presentAlert()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted))
    }
    
    
    //MARK: - Private Functions
    //MARK: Fetch
    
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
                        print("No Challenge Found")
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
    
    ///Fetches the Challenge's week Goals
    func fetchWeekGoalsForCurrentChallenge() {
        guard let currentChallengeID = ChallengeController.shared.currentChallenge?.recordID else {return}
        let challengeReference = CKRecord.Reference(recordID: currentChallengeID, action: .none)
        print("Looking for week goals of current Challenge...")
        GoalController.shared.fetchGoals(withChallengeReference: challengeReference, completion: { (isSuccess) in
            if isSuccess {
                print("Week goals found")
                let weekGoalsOfChallengeFound = Notification(name: Notification.Name(rawValue: NotificationStrings.weekGoalsFound), object: nil, userInfo: nil)
                NotificationCenter.default.post(weekGoalsOfChallengeFound)
            } else {
                print("no week goals found")
            }
        })
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
    
    //MARK: Go to specific VC
    ///Segue to newUser VC
    func createNewUser() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SignUpParentViewController")
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    ///Segue to createChallenge VC
    func createNewChallenge() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "NewChallengeParentViewController")
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    ///Segue to currentChallenge VC if its before StartDate
    func currentChallenge() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "NewChallengeParentViewController")
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    ///Segue to addMonthGoal VC
    func addMonthGoal() {
        //TODO: Add logic to segue directly to the monthGoal screen
        currentChallenge()
    }
    
    ///Segue to activeChallenge VC its after StartDate
    func activeChallenge() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "ActiveChallengeController")
            self.present(viewController, animated: true, completion: nil)
        }
    }
}
