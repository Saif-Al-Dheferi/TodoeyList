//
//  Category.swift
//  TodoeyList
//
//  Created by Saif Aldheferi on 4/16/20.
//  Copyright © 2020 Saif Aldheferi. All rights reserved.
//

import Foundation
import RealmSwift


class Category:Object
{
     @objc dynamic var name:String=""
     let items=List<Item>()
  
}
