//
//  LocationTableViewCell.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/10/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable
import SnapKit
import SwifterSwift

class LocationTableViewCell: UITableViewCell, Reusable {
    let containerView = UIStackView()
    let cellImageView = UIImageView()
    
    let locationNameLabel = UILabel()
    let locationAddressLabel = UILabel()
    let locationPhoneLabel = UILabel()
    let locationEmailLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackView()
        setupConstraints()
        self.imageView?.image = #imageLiteral(resourceName: "Pin")
        Stylesheet.applyOn(self)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    func setupStackView() {
        self.contentView.addSubview(containerView)
        self.containerView.addArrangedSubview(locationNameLabel)
        self.containerView.addArrangedSubview(locationAddressLabel)
        self.containerView.addArrangedSubview(locationPhoneLabel)
        self.containerView.addArrangedSubview(locationEmailLabel)
        
        self.containerView.alignment = .center
        self.containerView.axis = .vertical
        self.containerView.distribution = .fillProportionally
        self.containerView.spacing = 4
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().priority(99)
            make.bottom.equalTo(containerView).offset(10).priority(100)
        }
        
        self.containerView.snp.makeConstraints { (make) in
            make.left.equalTo(self.imageView!.snp.right).offset(15)
            make.top.bottom.equalToSuperview().inset(15)
            make.right.equalToSuperview()
        }
    }
    
    func setupConstraints() {
        
        locationNameLabel.snp.makeConstraints { (make) -> Void in
//            make.top.equalToSuperview().inset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            
            make.height.equalTo(Helpers.calculateHeight(forHeight: 20))
        }
        
        locationAddressLabel.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(locationNameLabel.snp.bottom).offset(2)
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(5)
            
            let height: CGFloat = (28 * 2)
            make.height.equalTo(Helpers.calculateHeight(forHeight: height))
        }
        
        locationPhoneLabel.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(locationAddressLabel.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(5)
            
            make.height.equalTo(Helpers.calculateHeight(forHeight: 20))
        }
        
        locationEmailLabel.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(locationPhoneLabel.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(5)
            
            make.height.equalTo(Helpers.calculateHeight(forHeight: 20))
        }
        setupLabels()
    }
    
    func setupLabels() {
        locationNameLabel.adjustsFontSizeToFitWidth = false
        locationNameLabel.minimumScaleFactor = 0.25
        locationNameLabel.numberOfLines = 1
        locationNameLabel.lineBreakMode = .byTruncatingTail
        
        locationAddressLabel.adjustsFontSizeToFitWidth = true
        locationAddressLabel.minimumScaleFactor = 0.25
        locationAddressLabel.numberOfLines = 2
        
        locationPhoneLabel.adjustsFontSizeToFitWidth = true
        locationPhoneLabel.minimumScaleFactor = 0.25
        locationPhoneLabel.numberOfLines = 1
        
        locationEmailLabel.adjustsFontSizeToFitWidth = true
        locationEmailLabel.minimumScaleFactor = 0.25
        locationEmailLabel.numberOfLines = 1
    }
    
    func setupCell(pet item: PetModel) {
        //@TODO: Make part
        let boldState  = "State: "
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string:boldState, attributes:attrs)
        
        let normalText = (item.state ?? "")
        let normalString = NSMutableAttributedString(string:normalText)
        attributedString.append(normalString)
        
        let lineBreak = "\n"
        let lineBreakString = NSMutableAttributedString(string:lineBreak)
        attributedString.append(lineBreakString)
        
        let boldZip = "Zipcode: "
        let boldZipString = NSMutableAttributedString(string:boldZip, attributes:attrs)
        attributedString.append(boldZipString)
        
        let zipText = (item.zipcode ?? "")
        let zipString = NSMutableAttributedString(string:zipText)
        attributedString.append(zipString)
        
        locationNameLabel.text = ""
        locationNameLabel.isHidden = true
        locationAddressLabel.attributedText = attributedString
        locationPhoneLabel.text = item.phoneNumber
        locationEmailLabel.text = ""
        locationEmailLabel.isHidden = true
    }
    
    func setupCell(shelter item: ShelterModel) {
        locationNameLabel.text = item.getName()        
        locationAddressLabel.text = item.getCityState()
        locationPhoneLabel.text = item.phone ?? ""
        locationEmailLabel.text = item.email ?? ""
    }
}
