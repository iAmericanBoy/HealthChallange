//
//  GoalsViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/14/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class GoalsTableViewController: UITableViewController {
    
    @IBOutlet weak var optionsButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsImage()
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
    
    @IBAction func optionsButtonTapped(_ sender: Any) {
        
    }
    
    func settingsImage() {
        if let image = UserController.shared.loggedInUser?.photo {
            optionsButton.image = image
        } else {
            guard let image = UIImage(named: "stockPhoto"),
                let imageAsData = image.pngData()
                else { return }
            optionsButton.image = UIImage(data: imageAsData, scale: 10)
        }
    }
}
