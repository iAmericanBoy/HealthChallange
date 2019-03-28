//
//  FoodController.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/15/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//


import Foundation

class FoodController {
    
    
    static var food: [Ingredient] = []
    static let sharedInstance = FoodController()
    static let format = "json"
    static let sort = "r"   // n 
    static let max = 20
    static var offset = 0
    static let ds = "Standard Reference"
    static let apiKey = "GpyZeJCsTfea56Jcwwkd5lXGYyqpG2nFC0MQNtZx"
    static let baseURL = URL(string: "https://api.nal.usda.gov")
    static func getFood(query: String, completion: @escaping ((Bool) -> Void)) {
        
        guard var url = baseURL else {return}
        
        url.appendPathComponent("ndb")
        url.appendPathComponent("search")
        
        let format1 = URLQueryItem(name: "format", value: format)
        let foodQuery = URLQueryItem(name: "q", value: query.lowercased())
        let foodQueryQP = URLQueryItem(name: "qp", value: query.lowercased())
        let sort1 = URLQueryItem(name: "sort", value: sort)
        let offset1 = URLQueryItem(name: "offset", value: String(offset))
        let max1 = URLQueryItem(name: "max", value: String(max))
        let apiKeyQuery = URLQueryItem(name: "api_key", value: apiKey)
        let ds1 = URLQueryItem(name: "ds", value: ds)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [format1, foodQuery, foodQueryQP, sort1, offset1, max1, apiKeyQuery, ds1]
        
        guard let requestURL = components?.url else {completion(false); return}
        
        print(requestURL)
        
        var urlRequest = URLRequest(url: requestURL)
        
        urlRequest.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                print("error getting food items from the web: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let data = data else {
                print(" there wasn no data")
                completion(false)
                return
            }
            
            guard let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                print("json data was not converted into correct format")
                completion(false)
                return
            }
            
            var foodFromJson: [Ingredient] = []
            
            guard let jsonList :[String : Any] = jsonDictionary?["list"] as? [String : Any] else
            { print("jsonItems");  return }
            
            //print(jsonList)
            
            guard let items :[[String:Any]] = jsonList["item"] as? [[String: Any]] else
                
            {  print("got items"); return}
            
            for item in items {
               // print(items)
                
                if let newIngredient = Ingredient(dictionary: item) {
                    
                    foodFromJson.append(newIngredient)
                    //print(food)
                }
            }
            
            self.food.append(contentsOf: foodFromJson)
            completion(true)
            
        }
        dataTask.resume()
        
    }
    
    func incrementNutrients(for ingredient: Ingredient, scalar: Double){

        ingredient.scalar = scalar
        
        guard let nutrients = ingredient.nutrients else { return }
        if let calories = Double(nutrients.caloriesGM) {
            nutrients.calories = "\(calories * scalar)"
        }

        if let fats = Double(nutrients.fatsGM) {
            nutrients.fats = "\(fats * scalar)"
        }
        if let carbs = Double(nutrients.carbsGM) {
            nutrients.carbs = "\(carbs * scalar)"
        }
        if let sugar = Double(nutrients.sugarGM) {
            nutrients.sugar = "\(sugar * scalar)"
        }
        if let sodium = Double(nutrients.sodiumGM) {
            nutrients.sodium = "\(sodium * scalar)"
        }
    }
    
    func decrementNutrients(for ingredient: Ingredient, scalar: Double) {
        
        
        guard let nutrients = ingredient.nutrients else { return }
        if let calories = Double(nutrients.caloriesGM) {
            nutrients.calories = "\(calories * scalar)"
        }
        if let fats = Double(nutrients.fatsGM) {
            nutrients.fats = "\(fats * scalar)"
        }
        if let carbs = Double(nutrients.carbsGM) {
            nutrients.carbs = "\(carbs * scalar)"
        }
        if let sugar = Double(nutrients.sugarGM) {
            nutrients.sugar = "\(sugar * scalar)"
        }
        if let sodium = Double(nutrients.sodiumGM) {
            nutrients.sodium = "\(sodium * scalar)"
        }
    }

}
