//
//  FoodViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/14/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit
import Network

class DishCreatorViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var dishTableView: UITableView!
    @IBOutlet weak var dishName: UITextField!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mealSegment: UISegmentedControl!
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK: - Properties
    var ingredients: [Ingredient] = []
    var count = 0
    var searchTerm1 = ""  // paginate with same searchTerm
    let foods: [Ingredient] = []
    var foodEntry: FoodEntry?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        dishTableView.dataSource = self
        self.ingredientTableView.delegate = self
        self.ingredientTableView.dataSource = self
        self.dishTableView.tableFooterView = UIView()
        self.ingredientTableView.tableFooterView = UIView()
        self.dishName.delegate = self
        dishTableView.reloadData()
        
        // sets fonts
//        self.navigationController?.navigationBar.titleTextAttributes = FontController.titleFont
        saveButton.setAttributedTitle(NSAttributedString(string: "Save Meal", attributes: FontController.tableViewRowFontGREEN), for: .normal)
        dishName.attributedText = NSAttributedString(string: "", attributes: FontController.tableViewRowFont)
        monitorNetwork()
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
    
    //MARK: - Actions
    @IBAction func saveButtonTapped1(_ sender: Any) {
        print("save button tapped")
        guard let foodEntry = foodEntry else {return}
        guard let name = dishName.text, !name.isEmpty, ingredients.count > 0 else { return }
        DishController.shared.createDish(name: name, index: mealSegment.selectedSegmentIndex, ingredients: ingredients, inFoodEntry: foodEntry) { (isSuccess) in
            if isSuccess {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    //MARK: - Private Functions
    func monitorNetwork() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                self.dismissNetworkAlert()
            } else {
                print("No connection.")
                self.presentNoNetworkAlert()
            }
            
            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}

//MARK: - UISearchBarDelegate
extension DishCreatorViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else {return}
        //searchBar.resignFirstResponder()
        IngredientController.food = []
        IngredientController.getFood(query: searchTerm) { (success) in
            if success {
                DispatchQueue.main.async {
                    //searchBar.resignFirstResponder()
                    self.ingredientTableView.reloadData()
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension DishCreatorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //top tableView
        if tableView == ingredientTableView {
            
            return IngredientController.food.count
            
            //bottom tableView
        }else {
            return ingredients.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //bottom tableView
        
        if tableView == ingredientTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as? FoodTableViewCell
            cell?.delegate = self
            let foodItem = IngredientController.food[indexPath.row]
            
            cell?.itemLandingPad = foodItem
            return cell ?? UITableViewCell()
            
        }
        //Top tableView
        let dishCell = tableView.dequeueReusableCell(withIdentifier: "dishBuilderCell") as? DishBuilderTableViewCell
        
        let ingredientName1 = ingredients[indexPath.row]
        dishCell?.delegate = self
        dishCell?.dishBuilderLandingPad = ingredientName1
        
        return dishCell ?? UITableViewCell()
        
    }
    //delete rows for top tableView DishContructor tableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.ingredients.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //Pagination tableView protocol method
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row >= IngredientController.food.count - 1 {
            
            searchTerm1 = searchBar.text ?? ""
            
            let preFetchCount = IngredientController.food.count
            
            IngredientController.getFood(query: self.searchTerm1) { (success) in
                if success {
                    self.count += 1
                    IngredientController.offset = self.count * 10  // incrementing offset
                    
                    let postFetchCount = IngredientController.food.count
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

//MARK: - FoodTableViewCellDelegate
extension DishCreatorViewController: DishBuilderTableViewCellDelegate {
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
        IngredientController.sharedInstance.incrementNutrients(for: food, scalar: scalar)
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
        IngredientController.sharedInstance.decrementNutrients(for: food, scalar: scalar)
    }
}

//MARK: - FoodTableViewCellDelegate
extension DishCreatorViewController: FoodTableViewCellDelegate {
    func buttonCellButtontapped(_ sender: FoodTableViewCell) {
        guard let item = sender.itemLandingPad else {return}
        ingredients.append(item)
        dishTableView.reloadData()
    }
}

//MARK: - UITextFieldDelegate
extension DishCreatorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

