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
    var category: Category = Category()
    //contaxt
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadData()
        navigationItem.title = category.title
      
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
                newItem.categ = self.category
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
    
    func loadData(with request :NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil ){
        
        let catpPredicate = NSPredicate(format: "categ.title MATCHES[cd] %@",category.title!)
         if let addPredicate = predicate {
            
             request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [addPredicate,catpPredicate])
          
        }else{
            request.predicate = catpPredicate
        }
      
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
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
     
       
        loadData(with: request,predicate: predicate)
        

      
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadData()
               DispatchQueue.main.async {
                        searchBar.resignFirstResponder()
               }
        }
    }
}

