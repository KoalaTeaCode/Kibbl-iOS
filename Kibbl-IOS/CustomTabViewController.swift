//
//  CustomTabViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 4/28/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SideMenu
import SwifterSwift
import SnapKit

class CustomTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    var collectionView: UICollectionView!
    var ifset = false

    var bellButton = UIButton()
    var badgeView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let exitBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Menu"), style: .plain, target: self, action: #selector(self.presentLeftSideMenu))
        
        self.navigationItem.leftBarButtonItem = exitBarButton
        
        delegate = self
        
        self.view.backgroundColor = Stylesheet.Colors.white
        
        setupNavButton()
        setupTabs()
        setupSideMenu()
        setupTitleView()
        self.selectedIndex = 0
        // Updates observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.badgeCheck), name: .updates, object: nil)
    }
    
    func setupNavButton() {
//        let mailButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Mail"), style: .plain, target: self, action: nil)
//        let bellButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Bell"), style: .plain, target: self, action: nil)
//        navigationItem.rightBarButtonItems = [bellButton, mailButton]
        
//        guard let navBarHeight = self.navigationBar?.height else { return }
        let navBarHeight = 44.0
        let height = navBarHeight / 1.5
        let icon = #imageLiteral(resourceName: "Bell")
        let iconSize = CGRect(origin: .zero, size: CGSize(width: height, height: height))
        bellButton = UIButton(frame: iconSize)
        bellButton.setBackgroundImage(icon, for: .normal)
        bellButton.addTarget(self, action: #selector(self.updatesButtonPressed), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: bellButton)
        navigationItem.rightBarButtonItem = barButton
        
        // Add badge to bell icon
        badgeView = UIView()
        badgeView.backgroundColor = .red
        badgeView.cornerRadius = CGFloat(height / 6)
        bellButton.addSubview(badgeView)
        
        badgeView.snp.makeConstraints{ (make) in
            make.top.right.equalTo(bellButton).inset(2)
            make.height.width.equalToSuperview().dividedBy(3)
        }
        badgeView.isHidden = true
        badgeView.isUserInteractionEnabled = false
    }
    
    func updatesButtonPressed() {
        guard User.checkAndAlert() else { return }
        let vc = UpdatesCollectionViewController(collectionViewLayout: UICollectionViewLayout())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func badgeCheck() {
        switch UpdatesManager.shared.hasUpdates {
        case false:
            badgeView.isHidden = true
        default:
            badgeView.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTabs() {
        let layout = UICollectionViewLayout()
        let vc1 = HomeCollectionViewController(collectionViewLayout: layout)
        let vc2 = EventsCollectionViewController(collectionViewLayout: layout)
        let vc3 = PetsCollectionViewController(collectionViewLayout: layout)
        let vc4 = SheltersCollectionViewController(collectionViewLayout: layout)
        
        let icon1 = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "Bowl"), selectedImage: nil)
        let icon2 = UITabBarItem(title: "Events", image: #imageLiteral(resourceName: "Note"), selectedImage: nil)
        let icon3 = UITabBarItem(title: "Pets", image: #imageLiteral(resourceName: "Paw"), selectedImage: nil)
        let icon4 = UITabBarItem(title: "Shelters", image: #imageLiteral(resourceName: "Home"), selectedImage: nil)
        
        vc1.tabBarItem = icon1
        vc2.tabBarItem = icon2
        vc3.tabBarItem = icon3
        vc4.tabBarItem = icon4
        
        let controllers = [vc1,vc2,vc3,vc4]
        self.viewControllers = controllers
        
        self.tabBar.backgroundColor = Stylesheet.Colors.white
        self.tabBar.isTranslucent = false
    }
    
    func setupTitleView() {
        // @TODO: Some guard
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "kibblTitle"))
        guard let titleViewFrame = self.navigationItem.titleView?.frame else { return }
        let button = UIButton(frame: titleViewFrame)
        button.imageForNormal = #imageLiteral(resourceName: "kibblTitle")
        button.addTarget(self, action: #selector(self.titleButtonPressed), for: .touchUpInside)
        
        self.navigationItem.titleView = button
    }

    func titleButtonPressed() {
        guard collectionView != nil else { return }
        
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
    }
    
    func setChildCollectionView(to collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
}

extension CustomTabViewController {
    fileprivate func setupSideMenu() {
        // Define the menus
        guard !ifset else { return }
        let leftSideMenu = UISideMenuNavigationController(rootViewController: LeftViewController())
        SideMenuManager.menuLeftNavigationController = leftSideMenu
        ifset = true
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        //        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        //        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // Set up a cool background image for demo purposes
        //        SideMenuManager.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        SideMenuManager.menuFadeStatusBar = false
        
        SideMenuManager.menuPresentMode = .viewSlideInOut
    }
    
    func presentLeftSideMenu() {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
}
