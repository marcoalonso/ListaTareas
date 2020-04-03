//
//  CategoriaViewController.swift
//  ListaTareas
//
//  Created by marco alonso on 02/04/20.
//  Copyright © 2020 marco alonso. All rights reserved.
//

import UIKit
import CoreData
class CategoriaViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
             loadCategories()

    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }

    
    //MARK: - TableView Manipulation Methods
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("error saving category --> \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    
    func loadCategories() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error al cargar categorias \(error)")
        }
        
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
                                   
                                   let newCategory = Category(context: self.context)
                                   newCategory.name = textField.text!
                                   
                                   self.categories.append(newCategory) //agrega al arreglo la nueva categoria
                                   self.saveCategories()
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
               destinationVC.selectedCategory = categories[indexPath.row]
           }
       }
    
}
