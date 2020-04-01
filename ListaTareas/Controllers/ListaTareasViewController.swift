//
//  ViewController.swift
//  ListaTareas
//
//  Created by marco alonso on 29/03/20.
//  Copyright © 2020 marco alonso. All rights reserved.
//

import UIKit

class ListaTareasViewController: UITableViewController {
    
   var itemArray = ["Estudiar Xcode", "Ir a comprar comida","Sacar a Pudin a pasear"]
    //bd persistencia local
    let defaults = UserDefaults.standard
        override func viewDidLoad() {
            super.viewDidLoad()
            //si no existe nada guardado la app crasheará por eso se agrega if blet
            if let items = defaults.array(forKey: "ListaTareas") as? [String] {
                itemArray = items
            }
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemArray.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
            cell.textLabel?.text = itemArray[indexPath.row]
            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //print(itemArray[indexPath.row])
            //verificamos si tiene el checkmark cuando selecciona una celda
            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none //y la des-selecciona
                
            } else { //si no simplemente la marca con un check
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                
            }
            
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        // MARK - Add New Items
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //variable local para guardar el texto del usuario
        
        let alert = UIAlertController(title: "Agregar Nueva Nota", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Agregar Nota", style: .default) { (action) in
                // una vez que el usuario da click en agregar nota
            //Valida que no esté vacio el titulo de la nota
            if textField.text != "" {
                
                self.itemArray.append(textField.text!) //agrega al arreglo la nueva nota
                self.defaults.set(self.itemArray, forKey: "ListaTareas")
            }
            self.tableView.reloadData()
            }
        alert.addTextField { (alertTextField) in
            //configurar textFields
            alertTextField.placeholder = "Crear nueva nota"
            textField = alertTextField
            
            print(alertTextField.text!)
            
        }
            alert.addAction(action)
        
            present(alert, animated: true, completion: nil)
        
    }
    
    }


