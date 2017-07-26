//
//  LeftViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 6/14/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SideMenu

class LeftViewController: UIViewController {
    
    let logoutButton = UIButton()
    let containerView = UIView()
    var leftTableViewController = LeftTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Stylesheet.Colors.base
        
        self.navigationBar?.setColors(background: Stylesheet.Colors.base, text: Stylesheet.Colors.white)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(self.barButtonPressed))
        
        setupTableView()
        setupLogoutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLogoutButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView() {
        self.view.addSubview(containerView)
        containerView.backgroundColor = .red
        
        guard let navBarHeight = self.navigationBar?.height else { return }
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalToSuperview().dividedBy(1.25)
            make.centerY.equalToSuperview().offset(navBarHeight)
        }
        
        self.add(asChildViewController: leftTableViewController)
    }
    
    func setupLogoutButton() {
        self.view.addSubview(logoutButton)
        
        logoutButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalToSuperview().inset(15)
            make.left.right.equalToSuperview().inset(15)
            
            make.height.equalTo(Helpers.calculateHeight(forHeight: 40))
        }
        
        setLoginButtonTitle()
        
        logoutButton.setTitleColor(Stylesheet.Colors.white, for: .normal)
        logoutButton.setBackgroundColor(color: Stylesheet.Colors.light2, forState: .normal)
        logoutButton.addTarget(self, action: #selector(self.logoutPressed), for: .touchUpInside)
        logoutButton.cornerRadius = 8
    }
    
    func setLoginButtonTitle() {
        logoutButton.setTitle("Login", for: .normal)
        if User.getActiveUser()?.isLoggedIn() != false {
            logoutButton.setTitle("Logout", for: .normal)
        }
    }
    
    func logoutPressed() {
        if User.getActiveUser()?.isLoggedIn() != false {
            User.logout()
            setLoginButtonTitle()
            return
        }
        setLoginButtonTitle()
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func barButtonPressed() {
        self.dismiss(animated: true, completion: nil)
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
