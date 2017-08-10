//
//  SheltersCollectionViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 4/26/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import KoalaTeaFlowLayout
import Reusable

class SheltersCollectionViewController: UICollectionViewController {
    
    let realm = try! Realm()
    var token: NotificationToken?
    var data: Results<ShelterModel> = {
        
        return ShelterModel.getAllWithFilters().sorted(byKeyPath: "createdAt", ascending: false)
    }()
    
    let pageSize = 20
    let preloadMargin = 5
    
    var lastLoadedPage = 0
    var itemCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView?.register(cellType: ShelterCollectionViewCell.self)
        self.collectionView?.register(supplementaryViewType: FilterHeaderCollectionReusableView.self, ofKind: UICollectionElementKindSectionHeader)
        
        let ratio = 99.calculateHeight() / UIScreen.main.bounds.width
        let layout = KoalaTeaFlowLayout(ratio: ratio, topBottomMargin: 0, leftRightMargin: 0, cellsAcross: 1, cellSpacing: 0)
        self.collectionView?.collectionViewLayout = layout
        
        // Reload filter observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadForFilterChange), name: .filterChanged, object: nil)
        // Logging out observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadForFilterChange), name: .loggedOut, object: nil)
        
        self.view.backgroundColor = Stylesheet.Colors.white
        self.collectionView?.backgroundColor = Stylesheet.Colors.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let parentVC = self.parent as? CustomTabViewController {
            parentVC.setChildCollectionView(to: self.collectionView!)
        }
        
        registerNotifications()
        
        API.sharedInstance.getShelters()
    }
    
    func reloadForFilterChange() {
        data = ShelterModel.getAllWithFilters().sorted(byKeyPath: "createdAt", ascending: false)
        registerNotifications()
    }
    
    // MARK: - Data stuff
    
    func getData(page: Int = 0, lastItemDate: String = "") {
        lastLoadedPage = page
        API.sharedInstance.getShelters(createdAtBefore: lastItemDate)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if !data.isEmpty {
            if itemCount < 20 {
                self.getData()
            }
            return itemCount
        }
        self.getData()
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = data[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(for: indexPath) as ShelterCollectionViewCell
        
        // Configure the cell
        
        let nextPage: Int = Int(indexPath.item / pageSize) + 1
        let preloadIndex = nextPage * pageSize - preloadMargin
        
        if (indexPath.item >= preloadIndex && lastLoadedPage < nextPage) || indexPath == collectionView.indexPathForLastItem  {
            //            print("get next page : \(nextPage)")
            if let lastDate = item.createdAt {
                getData(page: nextPage, lastItemDate: lastDate)
            }
        }
        
        cell.setupCell(shelter: item)
        
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
        let vc = ShelterDetailTableViewController()
        vc.shelter = item
        self.navigationController?.pushViewController(vc)
    }
}

extension SheltersCollectionViewController {
    // MARK: Realm
    func registerNotifications() {
        token = data.addNotificationBlock {[weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                guard let int = self?.data.count else { return }
                self?.itemCount = int
                collectionView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                let deleteIndexPaths = deletions.map { IndexPath(item: $0, section: 0) }
                let insertIndexPaths = insertions.map { IndexPath(item: $0, section: 0) }
                let updateIndexPaths = modifications.map { IndexPath(item: $0, section: 0) }
                
                self?.collectionView?.performBatchUpdates({
                    self?.collectionView?.deleteItems(at: deleteIndexPaths)
                    if !deleteIndexPaths.isEmpty {
                        self?.itemCount -= 1
                    }
                    self?.collectionView?.insertItems(at: insertIndexPaths)
                    if !insertIndexPaths.isEmpty {
                        self?.itemCount += 1
                    }
                    self?.collectionView?.reloadItems(at: updateIndexPaths)
                }, completion: nil)
                break
            case .error(let error):
                print(error)
                break
            }
        }
    }
}


