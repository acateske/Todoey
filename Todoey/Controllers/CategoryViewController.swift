//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Aleksandar Tesanovic on 5/13/19.
//  Copyright © 2019 Aleksandar Tesanovic. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No add Category jet"
        guard let colorForCategory = categories?[indexPath.row].color else {fatalError()}
        cell.backgroundColor = UIColor(hexString: colorForCategory)
        if let color = UIColor(hexString: colorForCategory) {
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        return cell
    }
    
    //MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "gotoItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK:- Add new Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) {[weak self] (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = RandomFlatColor().hexValue()
            self?.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Category"
            textField = alertTextField
        }
        present(alert, animated: true)
    }
    
    //MARK:- Manipulating data
    
    func save(category: Category) {
        
        do {
        try realm.write {
            realm.add(category)
        }
        } catch {
            print("Error", error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func load() {
        
        categories = realm.objects(Category.self)
       
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error", error.localizedDescription)
            }
        }
    }
}

