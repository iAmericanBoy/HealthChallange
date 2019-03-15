//
//  FoodViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/14/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FoodTableViewCellDelegate {
    
    
    func buttonCellButtontapped(_ sender: FoodTableViewCell) {
        dish.append(sender.itemLandingPad!)
        print(sender.itemLandingPad?.name as Any)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var dish: [Food] = []
    var count = 0
    var searchTerm1 = ""  // paginate with same searchTerm
    let foods: [Food] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoodController.food.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as? FoodTableViewCell
        cell?.delegate = self
        let foodItem = FoodController.food[indexPath.row]
        
        NutrientsController.instance.getNutrients(food: foodItem, completion: { (success) in
            if success {
                DispatchQueue.main.async {
                    cell?.nutrientLandingPad = foodItem.nutrients
                }
            }
        })
        
        cell?.itemLandingPad = foodItem
        return cell ?? UITableViewCell()
        
    }
    
    //MARK: - Pagination tableView protocol method
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row >= FoodController.food.count - 1 {
            
            let preFetchCount = FoodController.food.count
            
            FoodController.getFood(query: self.searchTerm1) { (success) in
                if success {
                    self.count += 1
                    FoodController.offset = self.count * 10  // incrementing offset
                    
                    let postFetchCount = FoodController.food.count
                    if preFetchCount != postFetchCount {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            print("\(preFetchCount)")
                            print("\(postFetchCount)")
                            
                        }
                    }
                }
            }
        }
    }
}
//MARK: - segue to DishtableViewController

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDishVC" {
//            //if tableView.indexPathForSelectedRow != nil {
//            guard let destinationVC = segue.destination as? DishTableViewController else {return}
//
//            let dishToSend = dish
//            destinationVC.dishLandingPad = dishToSend
//
//        }
//    }
//}

//MARK: - dispatchGroup - submit multiple work items track when complete
//MARK: - SearchBar
extension FoodViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else {return}
        FoodController.getFood(query: searchTerm) { (success) in
            if success {
                //                let dispatchGroup = DispatchGroup()
                //                for food in FoodController.food {
                //                    dispatchGroup.enter()
                //                    NutrientsController.instance.getNutrients(food: food, completion: { (success) in
                //                        dispatchGroup.leave()
                //                    })
                //                }
                //                dispatchGroup.notify(queue: .main, execute: {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}



