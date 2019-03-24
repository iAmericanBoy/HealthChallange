//
//  FontController.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/23/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

struct FontController {
    
    static let labelFont = [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Avenir Next Condensed",UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.semibold]]), size: 20),NSAttributedString.Key.foregroundColor: UIColor.black]
    
    static let textFieldFont = [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Avenir Next Condensed",UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.semibold]]), size: 17),NSAttributedString.Key.foregroundColor: UIColor.black]
    
    static let subTitleLabelFont = [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Avenir Next Condensed",UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.medium]]), size: 13),NSAttributedString.Key.foregroundColor: UIColor.black]

    static let titleFont = [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Avenir Next Condensed",UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.heavy]]), size: 60),NSAttributedString.Key.foregroundColor: UIColor.purple]
    
    static let buttonFont = [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Avenir Next Condensed",UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.bold]]), size: 25),NSAttributedString.Key.foregroundColor: UIColor.lushGreenColor]
    

}
