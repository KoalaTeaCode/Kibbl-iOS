//
//  UpdatesDetailTableViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 6/22/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable

class UpdatesDetailTableViewController: UITableViewController {
    
    var updates: UpdatesModel!
    var petsData = [[PetModel]]()
    var eventsData = [[EventModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.register(cellType: PetTableViewCell.self)
        self.tableView.register(cellType: EventTableViewCell.self)
        
        tableView.allowsSelection = true
        tableView.alwaysBounceVertical = false
//        tableView.estimatedRowHeight = 20
        tableView.rowHeight = 99.calculateHeight()
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableFooterView = UIView()
        
        let view = ShelterDetailHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3))
        tableView.tableHeaderView = view
        //@TODO: Guard
        let shelter = updates.shelter.first!
        view.setupHeader(shelter: shelter)
        self.title = shelter.getName()
        loadData()
    }
    
    func loadData() {
        self.petsData = updates.getAllPetUpdates()
        self.eventsData = updates.getAllEventsUpdates()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard !petsData.isEmpty else { return 0 }
        guard !eventsData.isEmpty else { return 0 }
        switch section {
        case 1:
            if petsData[1].isEmpty {
                return 0
            }
            return petsData[1].count
        case 2:
            if eventsData[0].isEmpty {
                return 0
            }
            return eventsData[0].count
        case 3:
            if eventsData[1].isEmpty {
                return 0
            }
            return eventsData[1].count
        default:
            if petsData[0].isEmpty {
                return 0
            }
            return petsData[0].count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            // Pet
            let item = petsData[1][indexPath.row]
            
            let cell = tableView.dequeueReusableCell(for: indexPath) as PetTableViewCell
            
            // Configure the cell...
            cell.setupCell(model: item)
            
            return cell
        case 2:
            // Event
            let item = eventsData[0][indexPath.row]
            let cell = tableView.dequeueReusableCell(for: indexPath) as EventTableViewCell
            
            // Configure the cell...
            cell.setupCell(model: item)
            
            return cell
        case 3:
            // Event
            let item = eventsData[1][indexPath.row]
            let cell = tableView.dequeueReusableCell(for: indexPath) as EventTableViewCell
            
            // Configure the cell...
            cell.setupCell(model: item)
            
            return cell
        default:
            // Pet
            let item = petsData[0][indexPath.row]
            
            let cell = tableView.dequeueReusableCell(for: indexPath) as PetTableViewCell

            // Configure the cell...
            cell.setupCell(model: item)
            
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Updated Pets"
        case 2:
            return "New Events"
        case 3:
            return "Updated Events"
        default:
            return "New Pets"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Helpers.calculateHeight(forHeight: 20)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            // Pet
            let item = petsData[1][indexPath.row]
            
            let vc = PetDetailTableViewController()
            
            vc.pet = item
            
            self.navigationController?.pushViewController(vc)
        case 2:
            // Event
            let item = eventsData[0][indexPath.row]
            let vc = EventDetailTableViewController()
            
            vc.event = item
            
            self.navigationController?.pushViewController(vc)
        case 3:
            // Event
            let item = eventsData[1][indexPath.row]
            let vc = EventDetailTableViewController()
            
            vc.event = item
            
            self.navigationController?.pushViewController(vc)
        default:
            // Pet
            let item = petsData[0][indexPath.row]
            
            let vc = PetDetailTableViewController()
            
            vc.pet = item
            
            self.navigationController?.pushViewController(vc)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
