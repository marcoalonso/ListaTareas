//
//  ViewController.swift
//  ListaTareas
//
//  Created by marco alonso on 29/03/20.
//  Copyright © 2020 marco alonso. All rights reserved.
//

import UIKit

class ListaTareasViewController: UITableViewController {
    
   let itemArray = ["Estudiar Xcode", "Ir a comprar comida","Sacar a Pudin a pasear"]
        override func viewDidLoad() {
            super.viewDidLoad()
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
        
        
    }


