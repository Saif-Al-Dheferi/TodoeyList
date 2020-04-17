//
//  CategoTableViewController.swift
//  TodoeyList
//
//  Created by Saif Aldheferi on 4/12/20.
//  Copyright © 2020 Saif Aldheferi. All rights reserved.
//

import UIKit
import RealmSwift

class CategoTableViewController: UITableViewController
{
    let realm=try! Realm()
    var Categoreis:Results<Category>?
    //-----------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
              LoadCategory()
    }

// MARK: - Table view data source
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return Categoreis?.count ?? 1
        }
        //============================= Setting a value to the cell method =========================
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
             let cell=tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
             cell.textLabel?.text=Categoreis?[indexPath.row].name ?? "No Category"
             return cell
        }
        //=============================  didSelectRow method  ======================================
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            performSegue(withIdentifier: "Items_Seg", sender: self)
        }
   override func prepare(for segue: UIStoryboardSegue, sender: Any?)
      {
             let categovc = segue.destination as! ViewController
             if let indexPath=tableView.indexPathForSelectedRow
           {

               categovc.selectedCatego = Categoreis?[indexPath.row]
           }
          
      }

 @IBAction func addButton(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
//------------------------------------ Alert ------------------------------------------
               let alert=UIAlertController(title: " صنف جديد ", message: "", preferredStyle:.alert)
               let action = UIAlertAction(title: "اضافة", style: .default)
               {
                   (action) in
                     let newCategory=Category()
                     newCategory.name=textField.text!
                     self.Save(Categoreis: newCategory)
                     self.tableView.reloadData()
               }
                     alert.addTextField
                         {
                            (alertTextField) in
                            alertTextField.placeholder="اضافة صنف جديد"
                            textField=alertTextField
                         }
                     alert.addAction(action)
                     present(alert,animated: true,completion: nil)
    }
    //------------------------------------------------
    func Save(Categoreis:Category)
    {
        do
        {
            try realm.write
            {
                realm.add(Categoreis)
            }
        }
        catch
        {
            print("some thing is wrong")
        }
        self.tableView.reloadData()
    }
    //-----------------------------------------------
    func LoadCategory()
    {
        Categoreis=realm.objects(Category.self)
        tableView.reloadData()
    }
}
