//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Анастасия Беспалова on 07.10.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller doesn't exist")}
        
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].backgroundColor ?? "1D9BF6")
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: categories?[indexPath.row].backgroundColor ?? "1D9BF6")!, returnFlat: true)
        return cell
    }

   
    
    //MARK: - Data Manipulation Methods
    
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
            
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    func save(category: Category) {
        do {
                   try realm.write {
                       realm.add(category)
                   }
               } catch {
                   print("Error saving category \(error)")
               }
               tableView.reloadData()
    }
    
    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
              let alert = UIAlertController(title: "Add a New Cateogry", message: "", preferredStyle: .alert)
              let action = UIAlertAction(title: "Add", style: .default) { (action) in
                  let newCategory = Category()
                  newCategory.name = textField.text!
                  newCategory.backgroundColor = UIColor.randomFlat().hexValue()
                
                  self.save(category: newCategory)
              }
              
              alert.addAction(action)
              alert.addTextField { (field) in
                  textField = field
                  textField.placeholder = "Add a new category"
              }
              present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}
