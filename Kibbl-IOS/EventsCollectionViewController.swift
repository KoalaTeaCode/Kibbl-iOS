//
//  EventsCollectionViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/16/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import KoalaTeaFlowLayout
import Reusable

class EventsCollectionViewController: UICollectionViewController {
    
    var token: NotificationToken?
    var data: Results<EventModel> = {
        
        return EventModel.getAllWithFilters().sorted(byKeyPath: "start_time")
    }()
    
    let pageSize = 20
    let preloadMargin = 5
    var lastLoadedPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView?.register(cellType: EventsCollectionViewCell.self)
        self.collectionView?.register(supplementaryViewType: FilterHeaderCollectionReusableView.self, ofKind: UICollectionElementKindSectionHeader)
        
        let layout = KoalaTeaFlowLayout(ratio: 0.264, topBottomMargin: 0, leftRightMargin: 0, cellsAcross: 1, cellSpacing: 0)
        self.collectionView?.collectionViewLayout = layout
        
        self.collectionView?.showsVerticalScrollIndicator = false

        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadForFilterChange), name: .filterChanged, object: nil)
        
        self.view.backgroundColor = Stylesheet.Colors.white
        self.collectionView?.backgroundColor = Stylesheet.Colors.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let parentVC = self.parent as! CustomTabViewController
        parentVC.setChildCollectionView(to: self.collectionView!)
        
        registerNotifications()
        
        API.sharedInstance.getEvents()
    }
    
    func reloadForFilterChange() {
        data = EventModel.getAllWithFilters().sorted(byKeyPath: "start_time")
        registerNotifications()
    }
    
    func registerNotifications() {
        token = data.addNotificationBlock {[weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            
            switch changes {
            case .initial:
                collectionView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                let deleteIndexPaths = deletions.map { IndexPath(item: $0, section: 0) }
                let insertIndexPaths = insertions.map { IndexPath(item: $0, section: 0) }
                let updateIndexPaths = modifications.map { IndexPath(item: $0, section: 0) }
                
                self?.collectionView?.performBatchUpdates({
                    self?.collectionView?.deleteItems(at: deleteIndexPaths)
                    self?.collectionView?.insertItems(at: insertIndexPaths)
                    self?.collectionView?.reloadItems(at: updateIndexPaths)
                }, completion: nil)
                break
            case .error(let error):
                print(error)
                break
            }
        }
    }
    
    
    // MARK: - Data stuff
    
    func getData(page: Int = 0, lastItemDate: String = "") {
        lastLoadedPage = page
        API.sharedInstance.getEvents(createdAtBefore: lastItemDate)
    }

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if !data.isEmpty {
            if data.count < 20 {
                self.getData()
            }
            return data.count
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
        //@TODO: make this reflect pet collection view loading
        if (indexPath.item >= preloadIndex && lastLoadedPage < nextPage) || indexPath == collectionView.indexPathForLastItem  {
//            print("get next page : \(nextPage)")
            if let lastDate = item.start_time {
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
        let height = Helpers.calculateHeight(forHeight: 69.25)
        return CGSize(width: self.collectionView!.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        let vc = EventDetailTableViewController()
        vc.event = item
        self.navigationController?.pushViewController(vc)
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
}
