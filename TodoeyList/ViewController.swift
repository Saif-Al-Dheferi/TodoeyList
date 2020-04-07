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

    
    let itemArray=["Buy Some Eggs","Go to School","Get Some Milk"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDItemCell", for: indexPath)
        cell.textLabel?.text=itemArray[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
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
        tableView.deselectRow(at: indexPath, animated: true)
     }

}
