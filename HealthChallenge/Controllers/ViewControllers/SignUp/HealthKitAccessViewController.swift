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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: SignUpParentViewController.pageSwipedNotification, object: nil, userInfo: [SignUpParentViewController.pageIndexKey : 1])
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted), object: nil, queue: .main) { (notification) in
            print("Second Notification Accepted")
            self.presentAlert()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted))
    }
    
    // MARK: - Actions
    @IBAction func allowButtonTapped(_ sender: Any) {
        HealthKitController.shared.authorizeHK { (success) in
            //handle
            
        }
    }
    
    @IBAction func dontAllowButtonTapped(_ sender: Any) {
    }
    
} // end class
