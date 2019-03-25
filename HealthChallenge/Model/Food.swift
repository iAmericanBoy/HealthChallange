//
//  Food.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/15/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation

class Food {
    
    let name: String
    let ndbno: String
    var weight: Double?      
    var measure: String? 
    var nutrients: Nutrients?
    var scalar: Double?  // need to sav
    
    init?(dictionary: [String: Any]) {
        
        guard let name = dictionary["name"] as? String,
            let ndbno = dictionary["ndbno"] as? String
            
            else {
                return nil
        }
        self.name = name
        self.ndbno = ndbno
        
    }
    
    static func == (lhs: Food, rhs: Food) -> Bool {
        return lhs.name == rhs.name && lhs.ndbno == rhs.ndbno
            &&  lhs.weight == rhs.weight && lhs.measure == rhs.measure   //*
    }
}
