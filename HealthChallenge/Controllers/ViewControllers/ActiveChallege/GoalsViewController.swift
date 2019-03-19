//
//  GoalsViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/14/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class GoalsViewController: UIViewController {
    
    @IBOutlet weak var optionsButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsImage()
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
