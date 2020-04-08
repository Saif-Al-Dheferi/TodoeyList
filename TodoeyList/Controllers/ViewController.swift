//
//  ViewController.swift
//  TodoeyList
//
//  Created by Saif Aldheferi on 4/7/20.
//  Copyright © 2020 Saif Aldheferi. All rights reserved.
//

import UIKit

class ViewController: UITableViewController
{
    let defualts=UserDefaults.standard
    
    var itemArray=[Item]()

    //=========================================================================================
    // MARK - ----------------------------First Load Method -----------------------------------
    //=========================================================================================
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let newItem=Item()
        newItem.title="Go to home"
        itemArray.append(newItem)
        
//        if let item=defualts.array(forKey: "ToDo")as? [String]
//        {
//            itemArray=item
//        }
    }
    //=========================================================================================
    // MARK ----------------------------- Tableview Func --------------------------------------
    //=========================================================================================
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count
    }
    //=========================================================================================
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         let cell=tableView.dequeueReusableCell(withIdentifier: "ToDItemCell", for: indexPath)
         cell.textLabel?.text=itemArray[indexPath.row].title
         cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
         return cell
    }
   //=========================================================================================
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        if let cell = tableView.cellForRow(at: indexPath)
        {
            if cell.accessoryType == .checkmark
            {
               cell.accessoryType = .none
            }
            else
            {
               cell.accessoryType = .checkmark
            }
        }
          tableView.reloadData()
          tableView.deselectRow(at: indexPath, animated: true)
     }
   //=========================================================================================
   // MARK- -----------------------------ButtonClick -----------------------------------------
   //=========================================================================================
    @IBAction func addItemButtonPress(_ sender: Any)
    {
        var textField = UITextField()
        let alert=UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "Add item", style: .default)
        {
            (action) in
            
              let newItem=Item()
              newItem.title=textField.text!
              self.itemArray.append(newItem)
           
//            self.defualts.set(self.itemArray, forKey: "ToDo")
              self.tableView.reloadData()
        }
              alert.addTextField
                  {
                     (alertTextField) in
                     alertTextField.placeholder=" Create new item"
                     textField=alertTextField
                  }
              alert.addAction(action)
              present(alert,animated: true,completion: nil)
    }
    //=========================================================================================
}
