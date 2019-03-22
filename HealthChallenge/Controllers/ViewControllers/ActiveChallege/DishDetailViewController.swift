//
//  DishViewController.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/20/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class DishDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
      @IBOutlet weak var dishTableView: UITableView!
    
    //MARK: - sending ingredient names
    var dish: Dish? 
//        didSet {
//            updateViews()
//        }
//    }
//
////    func updateViews(){
////
////        guard let dish = dish else {return}
////
////        for dish in dishes {
////
////
////
////
////        }
////   // }
////    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = dish?.dishName
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted), object: nil, queue: .main) { (notification) in
            print("Second Notification Accepted")
            self.presentAlert()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted))
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ingredients = dish?.ingredients else { return 0 }
        
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as? DishTableViewCell
        guard let dish = dish,
            let ingredients = dish.ingredients
            else { return UITableViewCell() }
        let ingredient = ingredients[indexPath.row]
        cell?.ingredientLandingPad = ingredient
  
        
        
        
        return cell ?? UITableViewCell()
    }
    

}

