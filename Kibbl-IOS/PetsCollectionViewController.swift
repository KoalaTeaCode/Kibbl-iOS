//
//  PetsCollectionViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 4/26/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import Reusable
import KoalaTeaFlowLayout

class PetsCollectionViewController: UICollectionViewController {
    
    var token: NotificationToken?
    var data: Results<PetModel> = {
        let data = PetModel.getAllWithFilters().sorted(byKeyPath: "lastUpdate", ascending: false)
        
        return data
    }()
    
    let repo = PetRepository.shared
    
    let pageSize = 20
    let preloadMargin = 5
    
    var lastLoadedPage = 0
    var itemCount = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        self.collectionView?.register(cellType: PetCollectionViewCell.self)
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
            parentVC.setChildCollectionView(to: self)
            
            // Set navigation item to searh button
            let rightBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.searchBarButtonPressed))
            parentVC.navigationItem.rightBarButtonItem = rightBarButton
        }
        
        self.registerNotifications()
    }
    
    func searchBarButtonPressed() {
        let vc = PetsSearchTableViewController()
        let navVC = UINavigationController(rootViewController: vc)
        self.navigationController?.present(navVC, animated: true, completion: nil)
    }
    
    func reloadForFilterChange() {
        data = PetModel.getAllWithFilters().sorted(byKeyPath: "lastUpdate", ascending: false)
        registerNotifications()
    }

    // MARK: - Data stuff
    
    func getData(page: Int = 0, lastItemDate: String = "") {
        lastLoadedPage = page
        //        API.sharedInstance.getEvents(createdAtBefore: lastItemDate)
        
        repo.getData(lastItemDate: lastItemDate, onSucces: { (returnedData) in
            //            for item in returnedData {
            //                let existingObject = self.data2.filter { $0.key! == item.key! }.first
            //                guard existingObject == nil else { continue }
            //                self.data2.append(item)
            //            }
            //            // Guard for new data
            //            guard self.lastData != returnedData else {
            //                //@TODO: Handle some error
            //                log.error("here")
            //                return
            //            }
            //            self.lastData = returnedData
            //            DispatchQueue.main.async(execute: {
            //                self.collectionView?.reloadData()
            //            })
            self.registerNotifications()
        }) { (error) in
            log.error(error)
        }
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
        
        let cell = collectionView.dequeueReusableCell(for: indexPath) as PetCollectionViewCell
        
        // Configure the cell
        
        let nextPage: Int = Int(indexPath.item / pageSize) + 1
        let preloadIndex = nextPage * pageSize - preloadMargin
        
        if (indexPath.item >= preloadIndex && lastLoadedPage < nextPage) || indexPath == collectionView.indexPathForLastItem {
            if let lastDate = item.lastUpdate {
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
        reusableview?.fromViewController = self
        
        return reusableview ?? UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let height = 69.25.calculateHeight()
        
        return CGSize(width: self.collectionView!.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        
        let vc = PetDetailTableViewController()
        
        vc.pet = item
        
        self.navigationController?.pushViewController(vc)
    }
}


extension PetsCollectionViewController {
    // MARK: Realm
    func registerNotifications() {
        token = data.observe {[weak self] (changes: RealmCollectionChange) in
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
                    self?.itemCount -= deleteIndexPaths.count
                    self?.collectionView?.insertItems(at: insertIndexPaths)
                    self?.itemCount += insertIndexPaths.count
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
