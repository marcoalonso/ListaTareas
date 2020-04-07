//
//  CategoriaViewController.swift
//  ListaTareas
//
//  Created by marco alonso on 02/04/20.
//  Copyright © 2020 marco alonso. All rights reserved.
//

import UIKit
import RealmSwift

class CategoriaViewController: UITableViewController {
    //coreData
    var categories : Results<Category>?
    
    let realm = try! Realm()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
             loadCategories()

    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No se han agregado categorias aún"
        return cell
    }

    
    //MARK: - TableView Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving category --> \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
                
    }
    

    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField() //variable local para guardar el texto del usuario
                       
                           let alert = UIAlertController(title: "Agregar Nueva Categoria", message: "", preferredStyle: .alert)
                           let action = UIAlertAction(title: "Agregar", style: .default) { (action) in
                                   // una vez que el usuario da click en agregar nota
                               //Valida que no esté vacio el titulo de la nota
               //                if textField.text != "" {
               //                    //Agregar nuevo elemento a la lista
               //                    //acceso a la Clase AppDelegate como objeto
                                   
                                   let newCategory = Category()
                                   newCategory.name = textField.text!
                                   
                                    self.save(category: newCategory)
                                   //print(self.categories)
                                   
                               //} //end if validation
                           } //end clousure in
                               alert.addAction(action)
                               alert.addTextField { (field) in
                               //configurar textFields
                                   textField = field
                                   textField.placeholder = "Crear nueva Categoria"
                               } // end closure in
                               
                               present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           performSegue(withIdentifier: "GoToItems", sender: self)
           
       }
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           let destinationVC = segue.destination as! ListaTareasViewController
           
           if let indexPath = tableView.indexPathForSelectedRow {
               destinationVC.selectedCategory = categories?[indexPath.row]
           }
       }
    
}
