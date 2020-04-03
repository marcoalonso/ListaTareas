//
//  ViewController.swift
//  ListaTareas
//
//  Created by marco alonso on 29/03/20.
//  Copyright © 2020 marco alonso. All rights reserved.
//

import UIKit
import CoreData

class ListaTareasViewController: UITableViewController {
    
   var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    //bd persistencia local
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
         
        }

// MARK: - TableViewMethods
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemArray.count
        }
    
    
        
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
            
            let item = itemArray[indexPath.row]
            
            cell.textLabel?.text = item.title
               //Verificar para marcar con ☑️ si esta seleccionada o no operador ternario
            cell.accessoryType = item.done == true ? .checkmark : .none
                 
            return cell
        }
    
    
    
    // MARK: - TableView Delegate Methods
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //verificamos si tiene el checkmark cuando selecciona una celda
            //itemArray[indexPath.row].setValue("Realizado", forKey: "title") //editar notas
            

//            context.delete(itemArray[indexPath.row]) //elimina de la bd but necesita saveContext()
//            itemArray.remove(at: indexPath.row) //elimina elemento de la matriz
            
            itemArray[indexPath.row].done = !itemArray[indexPath.row].done
            saveItems()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
    
    
        
        // MARK: - Add New Items
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField() //variable local para guardar el texto del usuario
        let alert = UIAlertController(title: "Agregar Nueva Nota", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Agregar Nota", style: .default) { (action) in
                // una vez que el usuario da click en agregar nota
            //Valida que no esté vacio el titulo de la nota
            if textField.text != "" {
                //Agregar nuevo elemento a la lista
                //acceso a la Clase AppDelegate como objeto
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem) //agrega al arreglo la nueva nota
                self.saveItems()
            }
            
           
        }
            alert.addTextField { (alertTextField) in
            //configurar textFields
            alertTextField.placeholder = "Crear nueva nota"
            textField = alertTextField
            
        }
            alert.addAction(action)
        
            present(alert, animated: true, completion: nil)
        
    }
    
   

    // MARK: - Model Manipulation Methods

    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("error saving context --> \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
    
    //establecer un valor por defecto por si llamamos SIN request
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        //crear una solicitud
        
        do {
            //guardara los resultados en el Array cuando los cargue de sqlite
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context  -> \(error.localizedDescription)")
        }
        
        tableView.reloadData()
        
    }
    
}

//MARK: - SearchBar Methods
extension ListaTareasViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //"cd" insensible May o minus
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //ordenar los resultados de la busqueda
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request) //with external parameter & request: internal parameter
       
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
