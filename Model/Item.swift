//
//  Item.swift
//  TodoeyList
//
//  Created by Saif Aldheferi on 4/17/20.
//  Copyright © 2020 Saif Aldheferi. All rights reserved.
//

import Foundation
import RealmSwift


class Item:Object
{
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    var parentCategory = LinkingObjects(fromType:Category.self,property:"items")
}
