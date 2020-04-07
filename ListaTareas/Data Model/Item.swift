//
//  Item.swift
//  ListaTareas
//
//  Created by marco alonso on 03/04/20.
//  Copyright © 2020 marco alonso. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
