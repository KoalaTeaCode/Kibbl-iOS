//
//  EventDetailTableViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/3/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

class PetDetailTableViewController: UITableViewController {
    
    var pet: PetModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.register(cellType: PetDetailDescTableViewCell.self)
        self.tableView.register(cellType: EmbeddedCollectionViewTableViewCell.self)
        self.tableView.register(cellType: CustomTableCell.self)
        self.tableView.register(cellType: LocationTableViewCell.self)
        
        tableView.allowsSelection = false
        tableView.alwaysBounceVertical = false
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .singleLine
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableFooterView = UIView()
        
        let view = PetDetailHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3), pet: pet)
        
        tableView.tableHeaderView = view
        
        self.title = pet.getName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(for: indexPath) as PetDetailDescTableViewCell
            
            // Configure the cell...
            cell.setupCell(pet)
            
            return cell
//        case 1:
//            let cell = tableView.dequeueReusableCell(for: indexPath) as EmbeddedCollectionViewTableViewCell
//            
//            // Configure the cell...
//            
//            
//            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(for: indexPath) as CustomTableCell
            
            // Configure the cell...
            cell.textLabel?.text = "Comments"
            cell.imageView?.image = #imageLiteral(resourceName: "Comment")
            cell.imageView?.contentMode = .scaleAspectFit
            cell.accessoryType = .disclosureIndicator
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(for: indexPath) as LocationTableViewCell
            
            cell.setupCell(pet: pet)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(for: indexPath) as PetDetailDescTableViewCell
            
            // Configure the cell...
            
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = .zero
        }
        
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins))  {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if cell.responds(to: #selector(setter: UIView.layoutMargins))  {
            cell.layoutMargins = .zero
        }
//        cell.isSelected = (indexPath as NSIndexPath).row == selectedRowIndex
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
