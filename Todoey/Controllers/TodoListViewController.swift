//
//  ViewController.swift
//  Todoey
//
//  Created by Aleksandar Tesanovic on 5/9/19.
//  Copyright © 2019 Aleksandar Tesanovic. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var items: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            load()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let color = selectedCategory?.color else {fatalError()}
        updateNavBar(with: color)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let hexColor = "00B0FF"
        updateNavBar(with: hexColor)
    }
    
    func updateNavBar(with colorHex: String) {
        
        title = selectedCategory?.name
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation bar dont exist!")}
        navBar.barTintColor = UIColor(hexString: colorHex)
        searchBar.barTintColor = UIColor(hexString: colorHex)
        guard let navBarColor = UIColor(hexString: colorHex) else {return}
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
    }

    //MARK:- TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title

            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(CGFloat(indexPath.row)/CGFloat(items!.count))) {
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                cell.backgroundColor = color
            }
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No item add yet"
        }
        return cell
    }
    
    //MARK:- TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error", error.localizedDescription)
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:  Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { [weak self](action) in
            
           if let currentCategory = self?.selectedCategory {
                do {
                    try self?.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving data")
                }
            }
           self?.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Item"
            textField = alertTextField
        }
        present(alert, animated: true)
    }
    
    //MARK:- Data manipulating methods
    
    func load() {
        
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = items?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                print("Error",error.localizedDescription)
            }
        }
    }
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        items = items?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text!.count == 0 {
            load()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

