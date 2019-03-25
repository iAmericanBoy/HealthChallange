//
//  FontController.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/23/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

struct FontController {
    
    static let labelTitleFont = [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Avenir Next Condensed",UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.semibold]]), size: 20),NSAttributedString.Key.foregroundColor: UIColor.black]
    
    static let tableViewRowFont = [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Avenir Next Condensed",UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.semibold]]), size: 17),NSAttributedString.Key.foregroundColor: UIColor.black]
    
    static let tableViewRowFontGRAY = [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Avenir Next Condensed",UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.semibold]]), size: 17),NSAttributedString.Key.foregroundColor: UIColor.gray]

    static let tableViewRowFontGREEN = [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Avenir Next Condensed",UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.semibold]]), size: 17),NSAttributedString.Key.foregroundColor: UIColor.lushGreenColor]

    static let textFieldFont = [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Avenir Next Condensed",UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.semibold]]), size: 17),NSAttributedString.Key.foregroundColor: UIColor.black]
    
    static let subTitleLabelFont = [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Avenir Next Condensed",UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.medium]]), size: 13),NSAttributedString.Key.foregroundColor: UIColor.black]

    static let titleFont = [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Avenir Next Condensed",UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.heavy]]), size: 55),NSAttributedString.Key.foregroundColor: UIColor.purple]
    
    static let enabledButtonFont = [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Avenir Next Condensed",UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.bold]]), size: 30),NSAttributedString.Key.foregroundColor: UIColor.lushGreenColor]
    
    static let disabledButtonFont = [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Avenir Next Condensed",UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.bold]]), size: 30),NSAttributedString.Key.foregroundColor: UIColor.purple]
    

}
