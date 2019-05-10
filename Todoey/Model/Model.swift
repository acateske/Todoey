//
//  Model.swift
//  Todoey
//
//  Created by Aleksandar Tesanovic on 5/9/19.
//  Copyright © 2019 Aleksandar Tesanovic. All rights reserved.
//

import Foundation

class Item: Codable {
    
    var title: String = ""
    var done: Bool = false
}
