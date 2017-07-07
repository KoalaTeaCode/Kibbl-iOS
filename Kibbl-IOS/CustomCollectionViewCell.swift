//
//  CustomCollectionViewCell.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/25/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable

class CustomCollectionViewCell: UICollectionViewCell, Reusable {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        //        Stylesheet.applyOn(self)
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.height / 2
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    func setupConstraints() {
        self.addSubview(titleLabel)
        
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.minimumScaleFactor = 0.25
        titleLabel.numberOfLines = 1
        titleLabel.contentMode = .center
        titleLabel.baselineAdjustment = .alignCenters
        
        titleLabel.textColor = UIColor(hex: 0x95928E)
        
        self.backgroundColor = UIColor(hex: 0xF9F9F9)
        //        titleLabel.sizeToFit()
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }
    }
}
