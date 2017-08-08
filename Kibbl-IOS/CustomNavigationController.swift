//
//  CustomNavigationController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 4/26/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SnapKit

class CustomNavigationController: UINavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !viewControllers.isEmpty {
            let pushingVC = viewControllers[viewControllers.count - 1]
            let backItem = UIBarButtonItem()
            backItem.title = ""
            pushingVC.navigationItem.backBarButtonItem = backItem
        }
        super.pushViewController(viewController, animated: animated)
    }
}

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Stylesheet.applyOn(self)
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return Stylesheet.Contexts.Global.StatusBarStyle
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
