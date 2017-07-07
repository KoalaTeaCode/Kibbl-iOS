//
//  ContainerView.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 6/9/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SnapKit
import SideMenu
import BetterSegmentedControl

class ContainerViewController: UIViewController {
    
    var containerView = UIView()
    var layoutSegmentControl = BetterSegmentedControl()
    let topBarView = UIView()
    let topBarHeight = UIScreen.main.bounds.size.height / 12
    
    private var firstVC = FavoritePetsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    private var secondVC = FavoriteEventsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        Stylesheet.applyOn(self)
        self.title = "Favorites"
        
//        guard let navBar = self.navigationController?.navigationBar else { return }
//        let size = navBar.height / 1.25
//        let imageSize = CGSize(width: size, height: size)
//        let image = UIImage(icon: .FABars, size: imageSize, textColor: .white, backgroundColor: .clear)
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func navButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        self.add(asChildViewController: firstVC)
        self.add(asChildViewController: secondVC)
    }
    
    // MARK: - View Methods
    
    private func setupView() {
        setupTopBar()
        
        self.view.addSubview(containerView)
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.topBarView.snp.bottom)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        containerView.backgroundColor = Stylesheet.Colors.white
        
        self.updateView()
    }
    
    func updateView() {
        if layoutSegmentControl.index == 0 {
            firstVC.view.isHidden = false
            secondVC.view.isHidden = true
        } else {
            firstVC.view.isHidden = true
            secondVC.view.isHidden = false
        }
    }
    
    func setupTopBar() {
        self.view.addSubview(topBarView)
        topBarView.backgroundColor = .white
        
        topBarView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            
            make.height.equalTo(topBarHeight)
        }
        
        self.setupSegmentControl()
    }
    
    func segmentedValueChanged(_ sender: BetterSegmentedControl!)
    {
        self.updateView()
    }
    
    func setupSegmentControl() {
        layoutSegmentControl = BetterSegmentedControl(
            frame: CGRect(x: 0, y: 0, width: 0, height: 0),
            titles: ["Pets", "Events"],
            index: 0,
            backgroundColor: .clear,
            titleColor: .clear,
            indicatorViewBackgroundColor: .clear,
            selectedTitleColor: .clear)
        layoutSegmentControl.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)
        
        self.topBarView.addSubview(layoutSegmentControl)
        
        layoutSegmentControl.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            make.width.equalToSuperview().dividedBy(1.5)
        }
    }
    
    // MARK: - Helper Methods
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        let height = containerView.height
        let width = containerView.width
        viewController.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    private func removeAllViewControllers() {
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
    }
}
