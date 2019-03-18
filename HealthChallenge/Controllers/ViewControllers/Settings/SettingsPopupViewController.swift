//
//  SettingsPopupViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/18/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class SettingsPopupViewController: UIViewController {
    
    var user: User?
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var challengesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func endChallengeButtonTapped(_ sender: Any) {
        guard let challenge = ChallengeController.shared.currentChallenge else { return }
        ChallengeController.shared.delete(challenge: challenge) { (success) in
            if success {
                // relaunch the app
            } else {
                // pop up no active challenge error?
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileVC" {
            guard let user = user else { return }
            let destinationVC = segue.destination as? SettingsTableViewController
            destinationVC?.user = user
        }
    }
}
