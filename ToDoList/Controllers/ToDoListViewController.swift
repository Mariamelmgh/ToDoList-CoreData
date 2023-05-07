//
//  ViewController.swift
//  ToDoList
//
//  Created by Mariam El Mgharaz on 1/5/2023.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    let defaults = UserDefaults.standard
    var toDoList: [Item] = []
    //contaxt
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
 
        loadData()
        
      
    }

    
    //MARK: Data Sourse
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusebleCell", for: indexPath)
        cell.textLabel?.text = toDoList[indexPath.row].title
        cell.accessoryType = toDoList[indexPath.row].done ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none

        return cell
    }
 
    
    //MARK: Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
//        context.delete(toDoList[indexPath.row])
        
        toDoList[indexPath.row].done  =  !toDoList[indexPath.row].done
       // saveContext()
        loadData()
//        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        
     
      
        
    }
    
    //MARK: Add Button Pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFieldReminder = UITextField()
        let alert = UIAlertController(title: "Add New Reminder", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add Reminder", style: .default) { action in
            if !textFieldReminder.text!.isEmpty {
                
                let newItem = Item(context: self.context)
                newItem.title = textFieldReminder.text
                newItem.done = false
              
                self.saveContext()
               
                self.loadData()
            }else{
                 
                let controllerAlert = UIAlertController(title: "Error", message: "Text Field must not be empty", preferredStyle: .alert)
                controllerAlert.addAction(.init(title: "OK", style: .cancel, handler: nil))
                self.present(controllerAlert, animated: true, completion: nil)
            }
            
        }
        
        
        alert.addTextField { textField in
            textField.placeholder = "Add your reminder here"
            
            textFieldReminder = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func loadData(){
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do{
            toDoList = try context.fetch(request)
        }catch{
            print("Error occured wile fetching data : \(error)")
        }
     
        tableView.reloadData()
    }
    
    func saveContext(){
        
        do{
            try context.save()
        }catch{
            print("Error occured  : \(error)")
        }
        
        
        
    }
    
    
}

extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()

        do{
            
            let  predicate = NSPredicate(format: "title CONTAINS %@",searchBar.text!)
            request.predicate = predicate
            try toDoList =  context.fetch(request)
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
          
            loadData()

        }catch{
            print("Error occured  : \(error)")
            
        }
    }
    
    
}

