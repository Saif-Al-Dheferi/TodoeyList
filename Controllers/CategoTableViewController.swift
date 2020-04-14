//
//  CategoTableViewController.swift
//  TodoeyList
//
//  Created by Saif Aldheferi on 4/12/20.
//  Copyright © 2020 Saif Aldheferi. All rights reserved.
//

import UIKit
import CoreData

class CategoTableViewController: UITableViewController
{
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var Categoreis=[Cate]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
           LoadItems()
    }

// MARK: - Table view data source
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return Categoreis.count
        }
        //============================= Setting a value to the cell method =========================
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
             let cell=tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
             cell.textLabel?.text=Categoreis[indexPath.row].name
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
             
               categovc.selectedCatego = Categoreis[indexPath.row]
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
                     let newItem=Cate(context: self.context)
                     newItem.name=textField.text!
                     self.Categoreis.append(newItem)
                     self.SaveItems()
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
    func LoadItems(with request:NSFetchRequest<Cate>=Cate.fetchRequest())
    {
        do
        {
        Categoreis=try context.fetch(request)
        }
        catch
        {
            print("error")
        }
    }
}
