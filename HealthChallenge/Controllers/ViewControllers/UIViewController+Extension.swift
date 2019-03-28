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
    
    func presentLoadingScreen() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func dismissAlert() {
        if let vc = self.presentedViewController, vc is UIAlertController {
            print(vc.title)
            dismiss(animated: false, completion: nil)
        }
    }
    func dismissNetworkAlert() {
        if let vc = self.presentedViewController, vc is UIAlertController {
            guard let title = vc.title , title == "No Internet Connection" else {return}
            dismiss(animated: false, completion: nil)
        }
    }
    
    func presentNoNetworkAlert() {
        let alert = UIAlertController(title: "No Internet Connection", message: nil, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
}
