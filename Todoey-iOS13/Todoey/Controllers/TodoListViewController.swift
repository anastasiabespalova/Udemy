//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()

    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colourHex = selectedCategory?.backgroundColor {
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller doesn't exist")}
            if let navBarColour = UIColor(hexString: colourHex) {
                navBar.barTintColor = navBarColour
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                searchBar.barTintColor = navBarColour
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
                
            }
            
            
        }
    }
    
    // MARK: -Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
               if let item = toDoItems?[indexPath.row] {
                   cell.textLabel?.text = item.title
                   if let color = UIColor(hexString: selectedCategory!.backgroundColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count) ) {
                       cell.backgroundColor = color
                       cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                   }
                   
                   cell.accessoryType = item.done ? .checkmark : .none
               } else {
                   cell.textLabel?.text = "No Items Added"
               }
               
               return cell
    }
    
    //MARK: -TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        if let item = toDoItems?[indexPath.row] {
                 do {
                     try realm.write{
                         // realm.delete(item)
                         item.done = !item.done
                     }
                 } catch {
                     print("Error saving done status, \(error)")
                 }
             }
             
             tableView.reloadData()
             tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
               let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
               let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                   if let currentCategory = self.selectedCategory {
                       do {
                           try self.realm.write {
                               let newItem = Item()
                               newItem.title = textField.text!
                               newItem.dateCreated = Date()
                               currentCategory.items.append(newItem)
                           }
                       } catch {
                           print("Error saving new items, \(error)")
                       }
                   }
                   self.tableView.reloadData()
               }
               alert.addTextField { (alertTextField) in
                   alertTextField.placeholder = "Create new item"
                   textField = alertTextField
               }
               alert.addAction(action)
               present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model manipulation
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
               tableView.reloadData()

        }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
}

// MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
             tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
                   loadItems()
                   DispatchQueue.main.async {
                       searchBar.resignFirstResponder()
                   }
               }
    }
}

