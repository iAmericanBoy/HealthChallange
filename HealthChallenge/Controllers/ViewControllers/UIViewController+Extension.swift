//
//  SecondChallenge.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/21/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

extension UIViewController {

    func presentAlert() {
        let alert = UIAlertController(title: "Second Challenge Accepted!", message: "Sorry but you can only be part of one challenge at a time.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            //Remove Participant From Share
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }

}
