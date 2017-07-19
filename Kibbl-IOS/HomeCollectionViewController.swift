//
//  HomeCollectionViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 4/26/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable
import KoalaTeaFlowLayout
import RealmSwift
import PKHUD
import FacebookCore
import FacebookLogin

class HomeCollectionViewController: UICollectionViewController {
    
    // Collection Properties
    var token: NotificationToken?
    
    var pets = Array<PetModel>()
    var shelters = Array<ShelterModel>()
    var events = Array<EventModel>()
    
    var notificationTokens = [NotificationToken]()
    var notificationToken: NotificationToken!
    
    var filterTopView: FilterHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //@tODO: Check if window key visible
//        HUD.show(.systemActivity)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView?.register(cellType: PetCollectionViewCell.self)
        self.collectionView?.register(cellType: ShelterCollectionViewCell.self)
        self.collectionView?.register(cellType: EventsCollectionViewCell.self)
        self.collectionView?.register(cellType: EventsCollectionViewCell.self)
        self.collectionView?.register(supplementaryViewType: CustomCollectionReusableView.self, ofKind: UICollectionElementKindSectionHeader)
        
        let ratio = 99.calculateHeight() / UIScreen.main.bounds.width
        let layout = KoalaTeaFlowLayout(ratio: ratio, topBottomMargin: 0, leftRightMargin: 0, cellsAcross: 1, cellSpacing: 0)
        self.collectionView?.collectionViewLayout = layout
        
        self.collectionView?.showsVerticalScrollIndicator = false
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Stylesheet.Colors.white
        self.collectionView?.backgroundColor = Stylesheet.Colors.white
        
        performLayout()
        
        API.sharedInstance.loadAllObjects()
        StateModel.createDefaults()
//        CityModel.createDefaults()
        
        // Logging out observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: .loggedOut, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
        
    func loadData() {
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            log.info("THIS")
            PetModel.getLatest(completionHandler: { (result: Array<PetModel>) in
                self.pets = result
                self.collectionView?.reloadData()
                HUD.hide()
            })
            EventModel.getLatest(completionHandler: { (result: Array<EventModel>) in
                self.events = result
                self.collectionView?.reloadData()
                HUD.hide()
            })
            ShelterModel.getLatest(completionHandler: { (result: Array<ShelterModel>) in
                self.shelters = result
                self.collectionView?.reloadData()
                HUD.hide()
            })
        }
    }
    
    func performLayout() {
        collectionView?.snp.makeConstraints{ (make) in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        switch  section {
        case 1:
            if !events.isEmpty {
                return events.count
            }
            return 0
        case 2:
            if !shelters.isEmpty {
                return shelters.count
            }
            return 0
        default:
            if !pets.isEmpty {
                return pets.count
            }
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.section {
        case 1:
            let event = events[indexPath.row]
            let cell = collectionView.dequeueReusableCell(for: indexPath) as EventsCollectionViewCell
            cell.setupCell(model: event)
            return cell
        case 2:
            let shelter = shelters[indexPath.row]
            let cell = collectionView.dequeueReusableCell(for: indexPath) as ShelterCollectionViewCell
            cell.setupCell(shelter: shelter)
            return cell
        default:
            let pet = pets[indexPath.row]
            let cell = collectionView.dequeueReusableCell(for: indexPath) as PetCollectionViewCell
            cell.setupCell(model: pet)
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: CustomCollectionReusableView.self, for: indexPath)
        
        switch indexPath.section {
        case 1:
            reusableview.titleLabel.text = "LATEST EVENTS"
        case 2:
            reusableview.titleLabel.text = "LATEST SHELTERS"
        default:
            reusableview.titleLabel.text = "LATEST PETS"
        }
        
        
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: self.collectionView!.width, height: self.view.height / 18)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let event = events[indexPath.row]
            let vc = EventDetailTableViewController()
            vc.event = event
            self.navigationController?.pushViewController(vc)
        case 2:
            let shelter = shelters[indexPath.row]
            let vc = ShelterDetailTableViewController()
            vc.shelter = shelter
            self.navigationController?.pushViewController(vc)
        default:
            let pet = pets[indexPath.row]
            let vc = PetDetailTableViewController()
            vc.pet = pet
            self.navigationController?.pushViewController(vc)
        }
    }
}

extension HomeCollectionViewController {
    func registerNotifications(for results: Results<PetModel>, in section:Int) {
        let notificationToken = results.addNotificationBlock { [unowned self] (changes: RealmCollectionChange) in
            guard let collectionView = self.collectionView else { return }
            
            switch changes {
            case .initial:
                collectionView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                let deleteIndexPaths = deletions.map { IndexPath(item: $0, section: section) }
                let insertIndexPaths = insertions.map { IndexPath(item: $0, section: section) }
                let updateIndexPaths = modifications.map { IndexPath(item: $0, section: section) }
                
                self.collectionView?.performBatchUpdates({
                    self.collectionView?.deleteItems(at: deleteIndexPaths)
                    self.collectionView?.insertItems(at: insertIndexPaths)
                    self.collectionView?.reloadItems(at: updateIndexPaths)
                }, completion: nil)
                break
            case .error(let error):
                print(error)
                break
            }
        }
        notificationTokens.append(notificationToken)
    }
    
    func registerNotifications(for results: Results<ShelterModel>, in section:Int) {
        let notificationToken = results.addNotificationBlock { [unowned self] (changes: RealmCollectionChange) in
            guard let collectionView = self.collectionView else { return }
            
            switch changes {
            case .initial:
                collectionView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                let deleteIndexPaths = deletions.map { IndexPath(item: $0, section: section) }
                let insertIndexPaths = insertions.map { IndexPath(item: $0, section: section) }
                let updateIndexPaths = modifications.map { IndexPath(item: $0, section: section) }
                
                self.collectionView?.performBatchUpdates({
                    self.collectionView?.deleteItems(at: deleteIndexPaths)
                    self.collectionView?.insertItems(at: insertIndexPaths)
                    self.collectionView?.reloadItems(at: updateIndexPaths)
                }, completion: nil)
                break
            case .error(let error):
                print(error)
                break
            }
        }
        notificationTokens.append(notificationToken)
    }
    
    func registerNotifications(for results: Results<EventModel>, in section:Int) {
        let notificationToken = results.addNotificationBlock { [unowned self] (changes: RealmCollectionChange) in
            guard let collectionView = self.collectionView else { return }
            
            switch changes {
            case .initial:
                collectionView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                let deleteIndexPaths = deletions.map { IndexPath(item: $0, section: section) }
                let insertIndexPaths = insertions.map { IndexPath(item: $0, section: section) }
                let updateIndexPaths = modifications.map { IndexPath(item: $0, section: section) }
                
                self.collectionView?.performBatchUpdates({
                    self.collectionView?.deleteItems(at: deleteIndexPaths)
                    self.collectionView?.insertItems(at: insertIndexPaths)
                    self.collectionView?.reloadItems(at: updateIndexPaths)
                }, completion: nil)
                break
            case .error(let error):
                print(error)
                break
            }
        }
        notificationTokens.append(notificationToken)
    }
}
