//
//  AddressTableViewCell.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/11/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable
import SnapKit
import SwifterSwift

class AddressTableViewCell: UITableViewCell, Reusable {
    let containerView = UIView()
    let cellImageView = UIImageView()
    
    let locationNameLabel = UILabel()
    let locationAddressLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(containerView)
        
        let views = [
            locationNameLabel,
            locationAddressLabel        ]
        self.containerView.addSubviews(views)
        
        
        
        setupConstraints()
        self.imageView?.image = #imageLiteral(resourceName: "Pin")
        Stylesheet.applyOn(self)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    func setupConstraints() {
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().priority(99)
            make.bottom.equalTo(containerView).priority(100)
        }
        
        self.containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(10)
            make.left.equalTo(self.imageView!.snp.right).offset(10)
            make.bottom.equalTo(locationAddressLabel).offset(30)
        }
        
        locationNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().inset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            
            make.height.equalTo(Helpers.calculateHeight(forHeight: 20))
        }
        
        locationAddressLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(locationNameLabel.snp.bottom).offset(2)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            
            make.height.equalTo(Helpers.calculateHeight(forHeight: 28))
        }

        setupLabels()
        
        //        containerView.snp.makeConstraints { (make) -> Void in
        //            make.top.left.right.equalToSuperview()
        //            make.bottom.equalTo(cellDetailLabel)
        //        }
    }
    
    func setupLabels() {
        locationNameLabel.adjustsFontSizeToFitWidth = false
        locationNameLabel.minimumScaleFactor = 0.25
        locationNameLabel.numberOfLines = 1
        locationNameLabel.lineBreakMode = .byTruncatingTail
        
        locationAddressLabel.adjustsFontSizeToFitWidth = true
        locationAddressLabel.minimumScaleFactor = 0.25
        locationAddressLabel.numberOfLines = 2
    }
    
    func setupCell(event item: EventModel) {
        self.locationNameLabel.text = item.locationName ?? ""
        self.locationAddressLabel.text = item.getStreet() + "\n" + item.getCityState()
    }
}
