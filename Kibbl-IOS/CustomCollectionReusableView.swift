//
//  CustomCollectionReusableView.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/3/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SnapKit
import Reusable

class CustomCollectionReusableView: UICollectionReusableView, Reusable {
    
    var fromViewController: UIViewController!
    
    var titleLabel = LabelWithAdaptiveTextHeight()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.performLayout()
        //        Stylesheet.applyOn(self)
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
    
    func performLayout() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 30)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.25
        titleLabel.numberOfLines = 1
        titleLabel.textColor = UIColor(hex: 0xB7B4B1)
    }
}


