//
//  LeftTableViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/11/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable
import RealmSwift

class LeftTableViewController: UITableViewController {
    
    var data = [
//        "Preferences",
        "Favorites"
        ,"Following"
        ,"Feedback"
//        ,"Updates"
//        ,"Settings"
//        ,"About"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.view.backgroundColor = Stylesheet.Colors.base
        
        self.tableView.register(cellType: TableViewCell.self)
        
        let screenHeight = UIScreen.main.bounds.height
        let divisor: CGFloat = 667 / 60
        let height = screenHeight / divisor
        
        tableView.rowHeight = height
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if !data.isEmpty {
            return data.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TableViewCell.self) as TableViewCell
        
        let item = data[indexPath.row]
        
        switch indexPath.row {
        case 1:
            cell.imageView?.image = #imageLiteral(resourceName: "Heart")
        default:
            cell.imageView?.image = #imageLiteral(resourceName: "Circle")
        }
        
        cell.textLabel?.text = item
        
        cell.imageView?.tintColor = .white
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        
        //@TODO: Add check for badge for updates
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = data[indexPath.row]
        
        switch item {
        case "Following":
            guard User.checkAndAlert() else { return }
            let vc = FollowingShelterCollectionViewController(collectionViewLayout: UICollectionViewLayout())
            self.navigationController?.pushViewController(vc, animated: true)
//        case "Updates":
//            guard User.checkAndAlert() else { return }
//            let vc = UpdatesCollectionViewController(collectionViewLayout: UICollectionViewLayout())
//            self.navigationController?.pushViewController(vc, animated: true)
        case "Favorites":
            guard User.checkAndAlert() else { return }
            let vc = ContainerViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case "Feedback":
            let vc = FeedbackViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        // Present Pref
        case "Preferences":
            log.info("prefs")
            // Present Pref
        case "Settings":
            log.info("settings")
        // Present Pref
        default: // About
            log.info("about")
            // Present About
        }
    }
}

class TableViewCell: UITableViewCell, Reusable {}
