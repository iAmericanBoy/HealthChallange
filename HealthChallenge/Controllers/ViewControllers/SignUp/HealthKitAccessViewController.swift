//
//  HealthKitAccessViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class HealthKitAccessViewController: UIViewController {
    
    let challengeController = ChallengeController()
    
    // MARK: - Outlets
    @IBOutlet weak var allowAccessLabel: UILabel!
    @IBOutlet weak var paragraphLabel: UILabel!
    @IBOutlet weak var allowButton: UIButton!
    @IBOutlet weak var dontAllowButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        UserController.shared.fetchUserLoggedInUser { (success) in
            if success {
                self.challengeController.fetchCurrentChallenge({ (success) in
                    // Show tab bar
                })
            } else {
                self.showNewChallengeVC()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: SignUpParentViewController.pageSwipedNotification, object: nil, userInfo: [SignUpParentViewController.pageIndexKey : 1])
    }
    
    // MARK: - Actions
    @IBAction func allowButtonTapped(_ sender: Any) {
        
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
