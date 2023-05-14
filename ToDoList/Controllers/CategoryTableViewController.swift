//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by Mariam El Mgharaz on 7/5/2023.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var cats :[Category] = []
    var currentCategory: Category = Category()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = cats[indexPath.row].title
        
        return cell
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textFieldCategory = UITextField()
        let alert = UIAlertController(title: "Add New Category",
                                      message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            if !textFieldCategory.text!.isEmpty{
                let newCategory = Category(context: self.context)
                
                newCategory.title = textFieldCategory.text
              
                
                self.saveContext()
                self.loadData()
            }else{
                let controllerAlert = UIAlertController(title: "Error", message: "Text Field must not be empty", preferredStyle: .alert)
                controllerAlert.addAction(.init(title: "OK", style: .default, handler: nil))

                self.present(controllerAlert, animated: true, completion: nil)
            }
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Add your category"
            textFieldCategory = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        let toDoViewController = segue.destination as! ToDoListViewController
        toDoViewController.category = self.currentCategory
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
        currentCategory = cats[indexPath.row]
        performSegue(withIdentifier: "GoToDo", sender: self)
    
    }
    
    
    
    func loadData(){
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do{
            cats = try context.fetch(request)
            
        }catch{
            
            print("Error occured : \(error)")
        }
        tableView.reloadData()
        
        
    }
    
    func saveContext(){
        do{
            try context.save()
        }catch{
            print("Error occured: \(error)")
        }
    }

}
