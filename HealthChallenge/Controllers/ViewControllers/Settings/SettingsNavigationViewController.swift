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
        let imageView = roundImage(photoData)
        let barButton = UIBarButtonItem(customView: imageView)
        navigationItem.setLeftBarButton(barButton, animated: false)
    }
    
    func roundImage(_ fromData: Data) -> UIImageView {
        let image = UIImage(data: fromData)
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 25, height: 25))
        imageView.image = image?.withRenderingMode(.alwaysOriginal)
        imageView.layer.cornerRadius = 20.0
        imageView.layer.masksToBounds = true
        return imageView
    }
}
