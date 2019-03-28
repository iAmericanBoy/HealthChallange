//
//  SettingsNavigationViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/22/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class SettingsNavigationViewController: UINavigationController {
    
    var photoData: Data {
        guard let userPhoto = UserController.shared.loggedInUser?.photoData else { return UIImage(named: "stockPhoto")!.pngData()!}
        return userPhoto
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSettingsButton()
    }
}
