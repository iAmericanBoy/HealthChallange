//
//  HealthKitAccessViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class HealthKitAccessViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var allowAccessLabel: UILabel!
    @IBOutlet weak var paragraphLabel: UILabel!
    @IBOutlet weak var allowButton: UIButton!
    @IBOutlet weak var dontAllowButton: UIButton!

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = UserController.shared.loggedInUser {
            if let currentChallenge = ChallengeController.shared.currentChallenge {
                //TODO: EditCurrent Challenge if before the startDate
            } else {
                self.showNewChallengeVC()
            }
        } else {
            //TODO: Add logic to deal with not having a logged in user
            self.showNewChallengeVC()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: SignUpParentViewController.pageSwipedNotification, object: nil, userInfo: [SignUpParentViewController.pageIndexKey : 1])
    }
    
    // MARK: - Actions
    @IBAction func allowButtonTapped(_ sender: Any) {
        HealthKitController.shared.authorizeHK { (success) in
            //handle 
        }
    }
    
    @IBAction func dontAllowButtonTapped(_ sender: Any) {
    }
    
    func showNewChallengeVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "NewChallengePageView")
            self.present(viewController, animated: true, completion: nil)
        }
    }
} // end class
