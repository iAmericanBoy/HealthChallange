//
//  FoodViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/14/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class DishCreatorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FoodTableViewCellDelegate, DishBuilderTableViewCellDelegate {
    
    //MARK: - Change measure Buttons
    func addAmountButtonTapped(_ sender: DishBuilderTableViewCell) {
        print("cell delegate made it to DishCreaterVC add")
        guard let food = sender.dishBuilderLandingPad else { return }
        guard let weight = food.weight else {return}
        
        sender.diffAmount += 1
        let change = weight + sender.diffAmount
        sender.diffLabel.text = "\(change) g"
        let scalar = (change / 100)
        if change >= 1 {
            sender.reduceAmountButton.isEnabled = true
        }
        FoodController.sharedInstance.incrementNutrients(for: food, scalar: scalar)
        //sender.updateViews()
        
    }
    func reduceAmountButtonTapped(_ sender: DishBuilderTableViewCell) {
        guard let food = sender.dishBuilderLandingPad else { return }
        guard let weight = food.weight else {return}
        
        
        
        let change = weight + sender.diffAmount
        if change < 0 {
            sender.reduceAmountButton.isEnabled = false
            return
        } else {
            sender.diffAmount -= 1
        }
        
        sender.diffLabel.text = "\(change) g"
        let scalar = (change / 100)
        FoodController.sharedInstance.decrementNutrients(for: food, scalar: scalar)
        //sender.updateViews()
    }
    
    @IBOutlet weak var dishTableView: UITableView!
    @IBOutlet weak var dishName: UITextField!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mealSegment: UISegmentedControl!
    
    @IBOutlet weak var noDishConstraint: NSLayoutConstraint!
    @IBOutlet weak var oneDishConstraint: NSLayoutConstraint!
    @IBOutlet weak var mutliDishConstraint: NSLayoutConstraint!
    var ingredients: [Food] = []
    var count = 0
    var searchTerm1 = ""  // paginate with same searchTerm
    let foods: [Food] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        dishTableView.dataSource = self
        self.ingredientTableView.delegate = self
        self.ingredientTableView.dataSource = self
        self.dishTableView.tableFooterView = UIView()
        self.ingredientTableView.tableFooterView = UIView()
        dishTableView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ingredientTableView.reloadData()
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted), object: nil, queue: .main) { (notification) in
            print("Second Notification Accepted")
            self.presentAlert()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted))
    }
    
    func buttonCellButtontapped(_ sender: FoodTableViewCell) {
        guard let item = sender.itemLandingPad else {return}
        //sender.itemLandingPad?.nutrients?.calories
        ingredients.append(item)
        dishTableView.reloadData()
        
        
        //dump(ingredients)
    }
    
    @IBAction func saveButtonTapped1(_ sender: Any) {
        print("save button tapped")
        
        guard let name = dishName.text,
            !name.isEmpty,
            
            ingredients.count > 0
            else { return }
        DishController.shared.createDish(name: name, index: mealSegment.selectedSegmentIndex, ingredients: ingredients)
        navigationController?.popViewController(animated: true)
        
       
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //MARK: - top tableView
        
        if tableView == ingredientTableView {
            
            return FoodController.food.count
            
        //MARK: - bottom tableView
        }
        _ = dishTableView
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK: - bottom tableView
        
        if tableView == ingredientTableView {
            
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
        //MARK: - Top tableView
        
        let dishCell = tableView.dequeueReusableCell(withIdentifier: "dishBuilderCell") as? DishBuilderTableViewCell
        
        
        let ingredientName1 = ingredients[indexPath.row] 
        dishCell?.delegate = self
        dishCell?.dishBuilderLandingPad = ingredientName1
        
        return dishCell ?? UITableViewCell()
        
    }
    //MARK: - delete rows for top tableView DishContructor tableView
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.ingredients.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
                            self.ingredientTableView.reloadData()
                            print("\(preFetchCount)")
                            print("\(postFetchCount)")
                            
                        }
                    }
                }
            }
        }
    }
}

//MARK: - SearchBar
extension DishCreatorViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else {return}
        FoodController.getFood(query: searchTerm) { (success) in
            if success {
                
                DispatchQueue.main.async {
                    self.ingredientTableView.reloadData()
                }
            }
        }
    }
}



