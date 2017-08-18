//
//  ShelterDetailTableViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/11/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable

class ShelterDetailTableViewController: UITableViewController {
    
    var shelter: ShelterModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.register(cellType: EventDetailDescTableViewCell.self)
        self.tableView.register(cellType: EmbeddedCollectionViewTableViewCell.self)
        self.tableView.register(cellType: CustomTableCell.self)
        self.tableView.register(cellType: LocationTableViewCell.self)
        self.tableView.register(cellType: PetTableViewCell.self)
        
        tableView.allowsSelection = false
        tableView.alwaysBounceVertical = false
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .singleLine
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableFooterView = UIView()
        
        let view = ShelterDetailHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3))
        tableView.tableHeaderView = view
        view.setupHeader(shelter: shelter)
        self.title = shelter.getName()
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
            let cell = tableView.dequeueReusableCell(for: indexPath) as EventDetailDescTableViewCell
            
            // Configure the cell...
            cell.setupCell(shelter: shelter)
            cell.fromVC = self
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(for: indexPath) as LocationTableViewCell
            
            // Configure the cell...
            cell.setupCell(shelter: shelter)
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(for: indexPath) as CustomTableCell
            
            // Configure the cell...
            cell.textLabel?.text = "Comments"
            cell.imageView?.image = #imageLiteral(resourceName: "Comment")
            cell.imageView?.contentMode = .scaleAspectFit
            cell.accessoryType = .disclosureIndicator
            
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
}
