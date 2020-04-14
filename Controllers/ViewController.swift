//
//  ViewController.swift
//  TodoeyList
//
//  Created by Saif Aldheferi on 4/7/20.
//  Copyright © 2020 Saif Aldheferi. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController
{
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var dataFilePath=FileManager.default.urls(for:.documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    var itemArray=[Item]()
    var selectedCatego: Cate?
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
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
       
        SaveItems()
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
              let newItem=Item(context: self.context)
              newItem.title=textField.text!
              newItem.done=false
              newItem.parent=self.selectedCatego
              self.itemArray.append(newItem)
              self.SaveItems()
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
        print(itemArray)
    }
     //=========================================================================================
    // MARK:- -----------------------Encoding Data into plist ----------------------------------
    //==========================================================================================
    
    func SaveItems()
    {
        do
        {
            try self.context.save()
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
    func LoadItems(with request:NSFetchRequest<Item>=Item.fetchRequest(), predicate : NSPredicate? = nil)
    {
        let Categorypredicate = NSPredicate(format:"parent.name MATCHES %@", selectedCatego!.name!)
        if let additionalPredicate = predicate
        {
             request.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [Categorypredicate,additionalPredicate])
        }
        else
        {
        request.predicate=Categorypredicate
        }
        do
        {
        itemArray=try context.fetch(request)
        }
        catch
        {
            print("error")
        }

    }
 
}
extension ViewController:UISearchBarDelegate
  {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
               let request:NSFetchRequest<Item>=Item.fetchRequest()
         request.predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        let titlepredicate=NSPredicate(format: "title CONTAINS %@", searchBar.text!)
          request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
         if searchBar.text?.count==0
          {
           LoadItems(with: request)
             DispatchQueue.main.async
                 {
                 searchBar.resignFirstResponder()
                 }
          }
          else
          {
            LoadItems(with: request,predicate: titlepredicate)
          }
               tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
//        searchBar.text=selectedCatego

    }
}
