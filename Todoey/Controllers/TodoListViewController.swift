//
//  ViewController.swift
//  Todoey
//
//  Created by Aleksandar Tesanovic on 5/9/19.
//  Copyright © 2019 Aleksandar Tesanovic. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var items = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let newItem1 = Item()
        newItem1.title = "Home go"
        items.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Buy drinks"
        items.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Do homework"
        items.append(newItem3)
        
        load()
    }

    //MARK:- TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    //MARK:- TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        items[indexPath.row].done = !items[indexPath.row].done
        save()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:  Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { [weak self](action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            self?.items.append(newItem)
            self?.save()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Item"
            textField = alertTextField
        }
        present(alert, animated: true)
    }
    
    //MARK:- Data manipulating methods
    
    func save() {
        
        let encoder = PropertyListEncoder()
        do {
        let data = try encoder.encode(items)
            guard let dataFilePath = dataFilePath else {fatalError()}
            try data.write(to: dataFilePath)
        } catch {
            print("Error with saving data")
        }
        tableView.reloadData()
    }
    
    func load() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error, can not retrive data")
            }
        }
    }
}

