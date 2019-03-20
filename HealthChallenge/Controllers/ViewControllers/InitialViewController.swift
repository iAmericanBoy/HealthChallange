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
                ChallengeController.shared.fetchCurrentChallenge { (isSuccess) in
                    if isSuccess {
                        //CURRENTCHALLENGE FOUND
                        //CHECK DATE
                        guard let challengeID = ChallengeController.shared.currentChallenge?.recordID, let userID = UserController.shared.appleUserID else {return}
                        
                        GoalController.shared.fetchUsersMonthGoal(withUserReference: CKRecord.Reference(recordID: userID, action: .none), andChallengeReference: CKRecord.Reference(recordID: challengeID, action: .none)) { (isSuccess) in
                            if isSuccess {
                                //MONTHGOAL FOR USER FOUND
                                DispatchQueue.main.async {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let viewController = storyboard.instantiateViewController(withIdentifier: "ActiveChallengeController")
                                    self.present(viewController, animated: true, completion: nil)
                                }
                            } else {
                                //MONTHGOAL FOR USER NOT FOUND
                                DispatchQueue.main.async {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    guard let viewController = storyboard.instantiateViewController(withIdentifier: "NewChallengeParentViewController") as? ChallengeOnboardingViewController else {return}
                                    viewController.isPresentingMonthGoalVC = true
                                    self.present(viewController, animated: true, completion: nil)
                                }
                            }
                        }
                    } else {
                        //NO CHALLENGE FOUND
                        DispatchQueue.main.async {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let viewController = storyboard.instantiateViewController(withIdentifier: "NewChallengeParentViewController")
                            self.present(viewController, animated: true, completion: nil)
                        }
                    }
                }
            } else {
                //USER NOT FOUND
                
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
