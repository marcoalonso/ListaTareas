//
//  Category.swift
//  ListaTareas
//
//  Created by marco alonso on 03/04/20.
//  Copyright © 2020 marco alonso. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    @objc dynamic var color : String = ""
    
}
