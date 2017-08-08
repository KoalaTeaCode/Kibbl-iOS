//
//  ViewEventsCollectionViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 8/8/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable
import KoalaTeaFlowLayout

class ViewEventsCollectionViewController: UICollectionViewController {
    
    var data = [EventModel]()
    
    let pageSize = 20
    let preloadMargin = 5
    
    var lastLoadedPage = 0
    var itemCount = 0
    
    var shelterId = ""
    
    var lastArray = [EventModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        self.collectionView?.register(cellType: EventsCollectionViewCell.self)
        self.collectionView?.register(supplementaryViewType: FilterHeaderCollectionReusableView.self, ofKind: UICollectionElementKindSectionHeader)
        
        let ratio = 99.calculateHeight() / UIScreen.main.bounds.width
        let layout = KoalaTeaFlowLayout(ratio: ratio, topBottomMargin: 0, leftRightMargin: 0, cellsAcross: 1, cellSpacing: 0)
        self.collectionView?.collectionViewLayout = layout
        
        self.view.backgroundColor = Stylesheet.Colors.white
        self.collectionView?.backgroundColor = Stylesheet.Colors.white
        
        self.title = "Shelter - Events"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let parentVC = self.parent as? CustomTabViewController {
            parentVC.setChildCollectionView(to: self.collectionView!)
        }
        
        if shelterId != "" {
            API.sharedInstance.getEvents(updatedAtBefore: "", shelterId: shelterId, completion: { (array) in
                guard let array = array else { return }
                self.data = array
                self.collectionView?.reloadData()
            })
            return
        }
    }
    
    // MARK: - Data stuff
    
    func getData(page: Int = 0, lastItemDate: String = "") {
        lastLoadedPage = page
        API.sharedInstance.getEvents(updatedAtBefore: lastItemDate, shelterId: shelterId, completion: { (array) in
            guard let array = array else { return }
            //@TODO: This isn't the best
            guard self.lastArray != array else { return }
            self.lastArray = array
            for item in array {
                let existingItem = self.data.filter { $0.key == item.key }.first
                if existingItem == nil {
                    self.data.append(item)
                }
            }
            self.collectionView?.reloadData()
        })
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if !data.isEmpty {
            if self.data.count < 20 {
                self.getData()
            }
            return self.data.count
        }
        self.getData()
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = data[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(for: indexPath) as EventsCollectionViewCell
        
        // Configure the cell
        
        let nextPage: Int = Int(indexPath.item / pageSize) + 1
        let preloadIndex = nextPage * pageSize - preloadMargin
        
        if (indexPath.item >= preloadIndex && lastLoadedPage < nextPage) || indexPath == collectionView.indexPathForLastItem {
            if let lastDate = item.createdAt {
                getData(page: nextPage, lastItemDate: lastDate)
            }
        }
        
        cell.setupCell(model: item)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: FilterHeaderCollectionReusableView.self, for: indexPath)
        reusableview.fromViewController = self
        
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        var height = 69.25.calculateHeight()
        
        if shelterId != "" {
            height = 0
        }
        
        return CGSize(width: self.collectionView!.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        
        let vc = EventDetailTableViewController()
        
        vc.event = item
        
        self.navigationController?.pushViewController(vc)
    }
}

