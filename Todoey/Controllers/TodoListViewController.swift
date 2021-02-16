//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    //use UserDefaults.standard to use the .plist / CoreData
    //let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //assiciate file for this app
        
        print(dataFilePath!)
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        //call load items function
       loadItems()
    }

    //Mark - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        
        //Ternary operator ==>
        // Value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark: .none
        
        return cell
        
    }
    
    //Mark - TableView Delegate Methods to print once tapped each cell
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
        
        //add check once cell is selected
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        

        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //Mark - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //action that happens once the user clicks  the Add Item button on our UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            print(textField.text!)
            
            self.itemArray.append(newItem)
            
            //storing value to phone memory in .plist file as an Array
            
            self.saveItems()
            
            //This line of the code is to access default plist
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //Mark - Model Manupulation Methods
    
    func saveItems () {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding \(error)")
            }
            
            
        }
        
        
        
    }
    
}

