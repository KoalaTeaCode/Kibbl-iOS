//
//  UpdatesCollectionViewCell.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 6/23/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable
import SnapKit

class UpdatesCollectionViewCell: UICollectionViewCell, Reusable {
    let titleLabel = UILabel()
    let descLabel = UILabel()
    let locationLabel = UILabel()
    let dateLabel = UILabel()
    
    let leftImageContentView = UIView()
    let rightImageContentView = UIView()
    
    let labelContentView = UIView()
    
    let titleView = ImageCircularView()
//    var shelterModel: ShelterModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        Stylesheet.applyOn(self)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    func setupConstraints() {
        self.contentView.addSubview(labelContentView)
        self.labelContentView.addSubview(titleLabel)
        self.labelContentView.addSubview(descLabel)
        self.labelContentView.addSubview(locationLabel)
        self.labelContentView.addSubview(rightImageContentView)
        self.rightImageContentView.addSubview(dateLabel)
        
        self.contentView.addSubview(leftImageContentView)
        
        self.leftImageContentView.addSubview(titleView)
        
        contentView.backgroundColor = .white
        
        setupLabels()
        
        leftImageContentView.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview()
            make.width.equalTo(contentView.width / 4)
            
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let labelHeightDivisor = 3.0
        
        rightImageContentView.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview().dividedBy(labelHeightDivisor)
            make.width.equalTo(contentView.width / 3.5)
            
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        
        labelContentView.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.left.equalTo(leftImageContentView.snp.right)
            
            make.top.equalTo(titleView.contentView.snp.top)
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            
            make.height.equalToSuperview().dividedBy(3.25)
        }
        
        descLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(leftImageContentView.snp.right)
            make.right.equalToSuperview().inset(20)
            
            make.height.equalToSuperview().dividedBy(3.5)
        }
        
        locationLabel.snp.makeConstraints { (make) -> Void in
            make.bottom.equalToSuperview()
            make.left.equalTo(leftImageContentView.snp.right)
            make.right.equalTo(rightImageContentView.snp.left)
            
            make.height.equalToSuperview().dividedBy(labelHeightDivisor)
        }
        
        //        commentImageButton.snp.makeConstraints { (make) -> Void in
        //            make.top.equalToSuperview().inset(2)
        //            make.bottom.equalToSuperview().inset(2)
        //            make.left.equalToSuperview()
        //            make.width.equalToSuperview().dividedBy(2)
        //        }
        //
        //        heartImageButton.snp.makeConstraints { (make) -> Void in
        //            make.top.equalToSuperview().inset(2)
        //            make.bottom.equalToSuperview().inset(2)
        //            make.right.equalToSuperview()
        //            make.width.equalToSuperview().dividedBy(2)
        //        }
        
        dateLabel.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
    }
    
    func setupLabels() {
        titleLabel.text = "County Animal Shelter"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.minimumScaleFactor = 0.25
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        
        descLabel.text = ""
        descLabel.font = UIFont.boldSystemFont(ofSize: 30)
        descLabel.adjustsFontSizeToFitWidth = false
        descLabel.minimumScaleFactor = 0.25
        descLabel.numberOfLines = 1
        
        locationLabel.text = "Baton Rouge, LA"
        locationLabel.font = UIFont.boldSystemFont(ofSize: 30)
        locationLabel.adjustsFontSizeToFitWidth = true
        locationLabel.minimumScaleFactor = 0.25
        locationLabel.numberOfLines = 1
        locationLabel.textAlignment = .left
        locationLabel.baselineAdjustment = .alignCenters
        
        dateLabel.text = ""
        dateLabel.font = UIFont.boldSystemFont(ofSize: 30)
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 0.25
        dateLabel.numberOfLines = 1
        dateLabel.textAlignment = .center
        dateLabel.baselineAdjustment = .alignCenters
    }
    
    func setupCell(update item: UpdatesModel!) {
        guard item != nil else { return }
        
        guard let shelter = item.shelter.first else { return }
        titleLabel.text = shelter.getName()
        descLabel.text =  shelter.about ?? ""
        locationLabel.text = shelter.getCityState()
        dateLabel.text = item.getFormattedTime()
        Stylesheet.applyOn(self)
    }
    
}


