//
//  ColorController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/17/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

enum Color {
    
    case theme // color for nav bar, button titles, progress bars.
    case border
    case shadow // shadows for cardlike views
    
    case darkBackground
    case lightBackground
    case intermediateBackground
    
    case darkText
    case lightText
    case intermediateText
    
    case affirmation // color to show success
    case negation // color to show error
    
    // create custom color
    case custom(hexString: String, alpha: Double)
    
    // add transparancey to extisting colors
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}


// Add hex value for ui elements and return the color.
extension Color {
    
    var value: UIColor {
        var instanceColor = UIColor.clear
        
        switch self {
        case .theme:
            instanceColor = UIColor(hexString: "#942192")
        case .border:
            instanceColor = UIColor(hexString: "#061306")
        case .shadow:
            instanceColor = UIColor(hexString: "#53F153")
        case .darkBackground:
            instanceColor = UIColor(hexString: "#3A2944")
        case .lightBackground:
            instanceColor = UIColor(hexString: "#D1E7D1")
        case .intermediateBackground:
            instanceColor = UIColor(hexString: "#6D696F")
        case .darkText:
            instanceColor = UIColor(hexString: "#942192")
        case .lightText:
            instanceColor = UIColor(hexString: "#EFCF8D")
        case .intermediateText:
            instanceColor = UIColor(hexString: "#7C5D8D")
        case .affirmation:
            instanceColor = UIColor(hexString: "#69A370")
        case .negation:
            instanceColor = UIColor(hexString: "#65653C")
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
        }
        return instanceColor
    }
}

extension UIColor {
    
    // Create a color from a hex string
    // Parameter: hexString in "#000000" format
    convenience init(hexString: String) {
        // Take hexString and turn it into hexidecimal value
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString as String)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        // Set color values for the hexidecimal
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    // Create color based on provided rgb int values
    // Parameters: red/green/blue integer value (0-255)
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
