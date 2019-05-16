//
//  Category.swift
//  Todoey
//
//  Created by Aleksandar Tesanovic on 5/14/19.
//  Copyright © 2019 Aleksandar Tesanovic. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
