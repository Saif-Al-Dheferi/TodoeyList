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
    var dataFilePath=FileManager.default.urls(for:.documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
   
    
    var itemArray=[Item]()

    //=========================================================================================
    //MARK: - ----------------------------First Load Method -----------------------------------
    //=========================================================================================
    override func viewDidLoad()
    {
        super.viewDidLoad()
         LoadItems()
    }
    //=========================================================================================
    //MARK:- ----------------------------- Tableview Func -------------------------------------
    //=========================================================================================
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count
    }
    //============================= Setting a value to the cell method =========================
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         let cell=tableView.dequeueReusableCell(withIdentifier: "ToDItemCell", for: indexPath)
         cell.textLabel?.text=itemArray[indexPath.row].title
         cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
         return cell
    }
    //=============================  didSelectRow method  ======================================
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        SaveItems()
     }
   //=========================================================================================
   // MARK:- -----------------------------ButtonClick ----------------------------------------
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
              self.SaveItems()
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
    // MARK:- -----------------------Encoding Data into plist ----------------------------------
    //==========================================================================================
    
    func SaveItems()
    {
        let encoder=PropertyListEncoder()
        do
        {
            let data = try encoder.encode(itemArray)
            print(data)
            try data.write(to: dataFilePath!)
        }
        catch
        {
            print("some thing is wrong")
        }
        self.tableView.reloadData()
    }
    //==========================================================================================
    // MARK: - -----------------------Decoding Data from plist ---------------------------------
    //==========================================================================================
    func LoadItems()
    {
        if  let data=try? Data(contentsOf: dataFilePath!)
        {
            
            let decoder=PropertyListDecoder()
            do
            {
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch
            {
                print("error")
            }
        }
    }
}
