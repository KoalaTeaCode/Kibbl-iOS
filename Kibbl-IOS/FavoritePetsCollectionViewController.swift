//
//  FavoritePetsCollectionViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 6/9/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import Reusable
import KoalaTeaFlowLayout

class FavoritePetsCollectionViewController: UICollectionViewController {
    
    var token: NotificationToken?
    var data: Results<PetModel> = {
        let data = PetModel.allFavorites().sorted(byKeyPath: "lastUpdate", ascending: false)
        
        return data
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        self.collectionView?.register(cellType: PetCollectionViewCell.self)
        
        let layout = KoalaTeaFlowLayout(ratio: 0.264, topBottomMargin: 0, leftRightMargin: 0, cellsAcross: 1, cellSpacing: 0, collectionViewHeight: self.view.height)
        self.collectionView?.collectionViewLayout = layout
        
        self.collectionView?.backgroundColor = Stylesheet.Colors.white
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        registerNotifications()
        
        API.sharedInstance.getFavorites()
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
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if !data.isEmpty {
            return data.count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = data[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(for: indexPath) as PetCollectionViewCell
        
        // Configure the cell
        
        cell.setupCell(model: item)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        
        let vc = PetDetailTableViewController()
        
        vc.pet = item
        
        self.navigationController?.pushViewController(vc)
    }
}
