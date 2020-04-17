//
//  ViewController.swift
//  TodoeyList
//
//  Created by Saif Aldheferi on 4/7/20.
//  Copyright © 2020 Saif Aldheferi. All rights reserved.
//
import UIKit
import RealmSwift

class ViewController: UITableViewController
{
    let realm=try! Realm()
    var items:Results<Item>?
    var selectedCatego: Category?
    {
        didSet
        {
            LoadItems()
        }
    }
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
        return items?.count ?? 1
    }
    //============================= Setting a value to the cell method =========================
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDItemCell", for: indexPath)
        if let item = items?[indexPath.row]
        {
            cell.textLabel?.text=item.title
            cell.accessoryType=item.done ? .checkmark : .none
        }
        else
        {
            cell.textLabel?.text="no item"
        }
         return cell
        }
    //=============================  didSelectRow method  ======================================
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
       if let item=items?[indexPath.row]
       {
        do
        {
            try realm.write
            {
                item.done = !item.done
            }
        }
        catch
            {
            print("\(error)")
            }
        
       }
        tableView.reloadData()
    }
   //=========================================================================================
   // MARK:- -----------------------------ButtonClick ----------------------------------------
   //=========================================================================================
    @IBAction func addItemButtonPress(_ sender: Any)
    {
        var textField = UITextField()
        //------------------------------------ Alert ------------------------------------------
        let alert=UIAlertController(title:"ادخل الفقرة الجديدة", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title:"اضافة", style: .default)
        {
         (action) in
          if let currentCategry = self.selectedCatego
            {
                 do
                 {
                    try self.realm.write
                       {
                           let newItem=Item()
                           newItem.title=textField.text!
                           currentCategry.items.append(newItem)
                           newItem.done=false
                       }
                }
                catch
                {
                    print("error \(error)")
                }
            }
         self.tableView.reloadData()
          }
         alert.addTextField
           {
            (alertTextField) in
            alertTextField.placeholder="اضافة عنصر جديد"
            textField=alertTextField
           }
         alert.addAction(action)
         present(alert,animated: true,completion: nil)
    }
     //=========================================================================================
    // MARK:- -----------------------Encoding Data into plist ----------------------------------
    //==========================================================================================
    
    func SaveItems(itemArray:Item)
    {
        do
        {
            try realm.write
            {
                realm.add(itemArray)
            }
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
        items = selectedCatego?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}
 extension ViewController:UISearchBarDelegate
  {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
         if searchBar.text?.count==0
         {
             LoadItems()
            DispatchQueue.main.async
                {
                searchBar.resignFirstResponder()
                }
         }
         else
         {
               items = selectedCatego?.items.filter("title CONTAINS %@", searchBar.text!)
         }
         tableView.reloadData()
    }
}
