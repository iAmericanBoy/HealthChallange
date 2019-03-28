//
//  NutrientsController.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/15/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation

class NutrientsController {
    
//    var nutrient: [Nutrients] = []
    static let instance = NutrientsController()
    let apiKey = "GpyZeJCsTfea56Jcwwkd5lXGYyqpG2nFC0MQNtZx"
    let format = "json"
    let baseURL = URL(string: "https://api.nal.usda.gov")
    
    // 204 = total Lipids, 205 = carbs, calories = 208, sugars = 269
    //--> // http://api.nal.usda.gov/ndb/nutrients/?format=json&api_key=DEMO_KEY&nutrients=205&nutrients=204&nutrients=208&nutrients=269&ndbno=01007
    
    func getNutrients(ingredient: Ingredient, completion: @escaping ((Bool) -> Void)) {
        
        guard var url = baseURL else {return}
        
        url.appendPathComponent("ndb")
        url.appendPathComponent("nutrients")
        
        let format1 = URLQueryItem(name: "format", value: format)
        let apiKeyQuery = URLQueryItem(name: "api_key", value: apiKey)
        let carbs = URLQueryItem(name: "nutrients", value: "205")     // carbs
        let calories = URLQueryItem(name: "nutrients", value: "208")  // calories
        let sugars = URLQueryItem(name: "nutrients", value: "269")    // sugars
        let fats = URLQueryItem(name: "nutrients", value: "204")      //fats
        let sodium = URLQueryItem(name: "nutrients", value: "307")    //sodium
        let ndbno = URLQueryItem(name: "ndbno", value: ingredient.ndbno)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems = [format1, apiKeyQuery, carbs, calories, sugars, fats, sodium, ndbno]
        
        guard let requestURL = components?.url else {completion(false); return}
        
        print(requestURL)
        
        var urlRequest = URLRequest(url: requestURL)
        
        urlRequest.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                print("error getting nutrient Food items from the web: \(error.localizedDescription)")
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
                
               // dump(jsonDictionary)
                
            }
            guard let jsonReport :[String: Any] = jsonDictionary?["report"] as? [String: Any] else {print("got report"); return}
           
            guard let jsonFoods :[[String: Any]] = jsonReport["foods"] as? [[String: Any]] else {print("got foods"); return}
            
            for foodDictionary in jsonFoods {
                if let weight = foodDictionary["weight"] as? Double,   
                let measure = foodDictionary["measure"] as? String {
                    ingredient.measure = measure
                    ingredient.weight = weight
                    //print(measure)
                }
                
                guard let jsonNutrients = foodDictionary["nutrients"] as? [[String: Any]] else {print("got jsonNutrients"); return}
                //print(jsonNutrients)
                
                if let nutrient = Nutrients( dictionary: jsonNutrients, weight : ingredient.weight ?? 0) {
                    //guard let weight = ingredient.weight else {return}
//                    print("=====nutrient======")
//                    print("food: \(food.name)")
//                    print("NDBNO: \(food.ndbno)")
//                    //print("weight: \(String(describing: food.weight))")     //*
//                    print("weight: \(weight)")
//                    print("measure: \(String(describing: food.measure))")
//                    print("calories: \(nutrient.calories)")
//                    print("sugar: \(nutrient.sugar)")
//                    print("fats: \(nutrient.fats)")
//                    print("carbs: \(nutrient.carbs)")
//                    print("sodium: \(nutrient.sodium)")
//                    print("=====nutrient======")
//                    print("😫😫😫😫😫😫😫😫😫😫NutrientGM😫😫😫😫😫😫😫😫😫😫😫")
//                    print("NDBNO: \(food.ndbno)")
//                    print("calories: \(nutrient.caloriesGM)")
//                    print("sugar: \(nutrient.sugarGM)")
//                    print("fats: \(nutrient.fatsGM)")
//                    print("carbs: \(nutrient.carbsGM)")
//                    print("sodium: \(nutrient.sodiumGM)")
//                    print("😫😫😫😫😫😫😫😫😫😫NutrientGM😫😫😫😫😫😫😫😫😫😫😫")
              
                    ingredient.nutrients = nutrient
                }
            }
            
            completion(true)
            //dump(jsonFoods)
        }
        dataTask.resume()
    }
    
    
}
