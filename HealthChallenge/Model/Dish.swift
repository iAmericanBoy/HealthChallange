//
//  Dish.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/15/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//
// save imageAsset and
//ingredientRef cant save custom objects to CK


import Foundation
import UIKit
import CloudKit

class Dish {
    
    var dishName: String
    var creatorReference: CKRecord.Reference?
    var ingredients: [Food] = []
    var photoData: Data? {
        didSet {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirecotryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirecotryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try photoData?.write(to: fileURL)
            } catch let error {
                print("Error writing to temp url \(error) \(error.localizedDescription)")
            }
            imageAsset = CKAsset(fileURL: fileURL)
        }
    }
    var dishType: DishType
    var timeStamp: Date = Date()
    var totalcal:Double = 0
    var totalcarbs:Double = 0
    var totalsugars:Double = 0
    var totalfats:Double = 0
    var totalsodium:Double = 0
    var ckRecordID: CKRecord.ID
    
    var ingredientRefs: [CKRecord.Reference] {
        var returnArray: [CKRecord.Reference] = []
        ingredients.forEach({ (food) in
            let ckreference = CKRecord.Reference(recordID: food.recordID, action: .deleteSelf)
            returnArray.append(ckreference)
        })
        return returnArray
    }
    
    var imageAsset: CKAsset?
//    {
//        get {
//            let tempDirectory = NSTemporaryDirectory()
//            let tempDirecotryURL = URL(fileURLWithPath: tempDirectory)
//            let fileURL = tempDirecotryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
//            do {
//                try photoData?.write(to: fileURL)
//            } catch let error {
//                print("Error writing to temp url \(error) \(error.localizedDescription)")
//            }
//            return CKAsset(fileURL: fileURL)
//        }
//    }
    
    var photo: UIImage? {
        get{
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        }
        set{
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    init(dishName: String, creator: CKRecord.Reference?, ingredients: [Food], dishType: DishType, timeStamp: Date, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.dishName = dishName
        self.ingredients = ingredients
        self.dishType = dishType
        self.timeStamp = timeStamp
        self.ckRecordID = ckRecordID
        self.creatorReference = creator
        
        var totalcal:Double = 0
        var totalcarbs:Double = 0
        var totalsugars:Double = 0
        var totalfats:Double = 0
        var totalsodium:Double = 0
        
        for ingredient in ingredients{
            
            let nutrients = ingredient.nutrients
            let nutrientCalories = Double( nutrients?.calories ?? "0" )
            let nutrientSugars = Double( nutrients?.sugar ?? "0" )
            let nutrientCarbs = Double( nutrients?.carbs ?? "0" )
            let nutrientFats = Double( nutrients?.fats ?? "0" )
            let nutrientsSodium = Double( nutrients?.sodium ?? "0" )
            
            totalcal += nutrientCalories ?? 0
            totalcarbs += nutrientCarbs  ?? 0
            totalsugars += nutrientSugars ?? 0
            totalfats += nutrientFats ?? 0
            totalsodium += nutrientsSodium ?? 0
        }
        
        self.totalcal = totalcal
        self.totalcarbs = totalcarbs
        self.totalsugars = totalsugars
        self.totalfats =  totalfats
        self.totalsodium = totalsodium
        
        
    }
    //MARK: - failable init() // builds record coming back from iCloud
    convenience init?(record: CKRecord) {
        guard let dishName = record[Dish.dishNameKey] as? String,
            let ingredients = record[Dish.ingredientRefsKey] as? [CKRecord.Reference],
            let photo = record[Dish.photoKey] as? CKAsset,
            let dishType = record[Dish.dishTypeKey] as? String,
            let timeStamp = record[Dish.timeStampKey] as? Date,
            let totalcal = record[Dish.totalCalKey] as? Double,
            let totalcarbs = record[Dish.totalCarbKey] as? Double,
            let totalsugars = record[Dish.totalsugarKey] as? Double,
            let totalfats = record[Dish.totalfatKey] as? Double,
            let totalsodium = record[Dish.totalSodiumKey] as? Double else {return nil}
        
        let dishTypeEnum = DishType(rawValue: dishType)
        
        self.init(dishName: dishName, creator: record[Goal.creatorReferenceKey] as? CKRecord.Reference, ingredients: [], dishType: dishTypeEnum!, timeStamp: timeStamp)
        
        self.totalcal = totalcal
        self.totalcarbs = totalcarbs
        self.totalsugars = totalsugars
        self.totalfats = totalfats
        self.totalsodium = totalsodium
        self.ckRecordID = record.recordID
        
        do {
            try self.photoData = Data(contentsOf: ((imageAsset?.fileURL)!))
        } catch {
            print("unable to unwrap photoData from the CKAsset. This is the error:  \(error), \(error.localizedDescription)")
        }
    }
}
// save raw value to CK
enum DishType: String {
    case Breakfast
    case Lunch
    case Dinner
    case Snack
}

// save ingredients as an array of non-objects and save images of type ckAssets not UIImage
// build a record for the cloud
extension CKRecord {
    convenience init(dish: Dish) {
        self.init(recordType: Dish.typeKey, recordID: dish.ckRecordID)
        
        self.setValue(dish.dishName, forKey: Dish.dishNameKey)
        self.setValue(dish.ingredientRefs, forKey: Dish.ingredientRefsKey)
        self.setValue(dish.creatorReference, forKey: Dish.creatorReferenceKey)
        self.setValue(dish.dishType.rawValue, forKey: Dish.dishTypeKey)
        self.setValue(dish.timeStamp, forKey: Dish.timeStampKey)
        self.setValue(dish.totalcal, forKey: Dish.totalCalKey)
        self.setValue(dish.totalcarbs, forKey: Dish.totalCarbKey)
        self.setValue(dish.totalsugars, forKey: Dish.totalsugarKey)
        self.setValue(dish.totalfats, forKey: Dish.totalfatKey)
        self.setValue(dish.totalsodium, forKey: Dish.totalSodiumKey)
        
        if dish.imageAsset != nil {
            self.setValue(dish.imageAsset, forKey: Dish.photoKey)
        }
    }
}


