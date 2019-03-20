//
//  DrawerView.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/19/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class DrawerView: UIView {
    
    
    static let shared = DrawerView()
    
    weak var delegate: DrawerViewControllerDelegate?
    @IBOutlet var drawerView: UIView!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    @IBAction func handlePan(_ sender: Any) {
        switch panGesture.state {
        case .began:
            delegate?.panViews(fromPoint: CGPoint(x: self.center.x, y: self.center.y + panGesture.translation(in: self).y))
            panGesture.setTranslation(CGPoint.zero, in: self)
        case .changed:
            delegate?.panViews(fromPoint: CGPoint(x: self.center.x, y: self.center.y + panGesture.translation(in: self).y))
            panGesture.setTranslation(CGPoint.zero, in: self)
        case .ended:
            panGesture.setTranslation(CGPoint.zero, in: self)
            delegate?.panDidEnd()
        default:
            return
        }
    }
    
}

protocol DrawerViewControllerDelegate: class {
    func panViews(fromPoint: CGPoint)
    func panDidEnd()
}
