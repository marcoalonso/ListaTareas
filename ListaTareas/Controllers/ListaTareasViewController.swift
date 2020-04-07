//
//  ViewController.swift
//  ListaTareas
//
//  Created by marco alonso on 29/03/20.
//  Copyright © 2020 marco alonso. All rights reserved.
//

import UIKit
import RealmSwift

class ListaTareasViewController: UITableViewController {
    
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
           loadItems()
        }
    }
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
         
        }

// MARK: - TableViewMethods
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return toDoItems?.count ?? 1
        }
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
            
            if let item = toDoItems?[indexPath.row] {
                
                cell.textLabel?.text = item.title
                   //Verificar para marcar con ☑️ si esta seleccionada o no operador ternario
                cell.accessoryType = item.done == true ? .checkmark : .none
            } else {
                cell.textLabel?.text = "No se han agregado tareas aún!"
            }
                 
            return cell
        }
    
    
    
    // MARK: - TableView Delegate Methods
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //verificamos si tiene el checkmark cuando selecciona una celda
            //itemArray[indexPath.row].setValue("Realizado", forKey: "title") //editar notas
            
            if let item = toDoItems? [indexPath.row] {
                do {
                    try realm.write{
                        //editar lista de hecho a sin hacer <->
                        item.done = !item.done
                        
                        //Eliminar notas
                        //realm.delete(item)
                    }

                } catch {
                    print("error saving items \(error)")
                }
            }
            
            tableView.reloadData()
           
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
    
    
        
        // MARK: - Add New Items
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField() //variable local para guardar el texto del usuario
        
        let alert = UIAlertController(title: "Agregar Nueva Nota", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Agregar Nota", style: .default) { (action) in
                
            //if textField.text != "" {
                //Agregar nuevo elemento a la lista
                //acceso a la Clase AppDelegate como objeto
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem =  Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error al guardar en bd realm \(error.localizedDescription)")
                    }
                }
            self.tableView.reloadData()
                
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

    
    
    //establecer un valor por defecto por si llamamos SIN request
    func loadItems(){

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    
}

// MARK: - SearchBar Methods
extension ListaTareasViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
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
