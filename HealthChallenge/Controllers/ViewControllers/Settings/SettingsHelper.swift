//
//  SettingsHelper.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/25/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class Settings {
    
    static let shared = Settings()
    
    /// Grab the photo data for a user, or set the image to the stock photo.
    var photoData: Data {
        guard let userPhoto = UserController.shared.loggedInUser?.photoData else { return UIImage(named: "stockPhoto")!.pngData()!}
        return userPhoto
    }
    
    /// Computed property of user photo into the round and scaled image.
    var imageView: UIImageView {
        return roundImage(photoData)
    }
    
    /// Create a round image view from the photo data
    func roundImage(_ fromData: Data) -> UIImageView {
        let image = UIImage(data: fromData)
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 20))
        imageView.image = image?.withRenderingMode(.alwaysOriginal)
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.masksToBounds = true
        return imageView
    }
}
