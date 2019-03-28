//
//  Extensions.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/20/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import UIKit.UIImage

extension Date {
    
    
    func format() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self)
    }
}

extension UIImage {
    
    func resize(to newSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { rendererContext in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
extension UIViewController {
    
    func setSettingsButton() {
        guard let _ = self.navigationController?.navigationBar else { return }
        let button = UIButton()
        let image = Settings.shared.imageView.image
        button.addTarget(self, action: #selector(showSettingsView), for: .touchUpInside)
        
        let resizedImage = image?.resize(to: CGSize(width: 40, height: 40))
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.setBackgroundImage(resizedImage, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.layer.cornerRadius = button.frame.width / 2
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationController?.navigationBar.addSubview(button)
        self.navigationItem.setRightBarButton(barButtonItem, animated: false)
    }
    
    @objc func showSettingsView() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Settings")
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

