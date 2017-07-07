//
//  VolunteerCollectionViewCell.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 4/28/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable
import SnapKit

class VolunteerCollectionViewCell: UICollectionViewCell, Reusable {
    let bottomBorder = UIView()
    let titleLabel = UILabel()
    let descLabel = UILabel()
    let pinImageView = UIImageView()
    let locationLabel = UILabel()
    let commentImageButton = UIButton()
    let heartImageButton = UIButton()
    
    let leftImageContentView = UIView()
    let rightImageContentView = UIView()
    
    let labelContentView = UIView()
    
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
        self.contentView.addSubview(bottomBorder)
        self.labelContentView.addSubview(titleLabel)
        self.labelContentView.addSubview(descLabel)
        self.labelContentView.addSubview(locationLabel)
        self.labelContentView.addSubview(leftImageContentView)
        self.labelContentView.addSubview(rightImageContentView)
        self.leftImageContentView.addSubview(pinImageView)
        self.rightImageContentView.addSubview(commentImageButton)
        self.rightImageContentView.addSubview(heartImageButton)
        
        contentView.backgroundColor = .white
        
        setupLabels()
        
        let labelHeightDivisor = 4
        
        leftImageContentView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(contentView.width / 20)
            make.left.equalToSuperview()
            make.top.equalTo(descLabel.snp.bottom)
            
            make.height.equalToSuperview().dividedBy(labelHeightDivisor)
        }
        
        rightImageContentView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(contentView.width / 3.5)
            make.right.equalToSuperview()
            make.top.equalTo(descLabel.snp.bottom)
            
            make.height.equalToSuperview().dividedBy(labelHeightDivisor)
        }
        
        labelContentView.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(9)
            make.bottom.equalToSuperview().inset(9)
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            
            make.height.equalToSuperview().dividedBy(3.5)
        }
        
        descLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            
            make.height.equalToSuperview().dividedBy(2.2)
        }
        
        locationLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(descLabel.snp.bottom)
            make.left.equalTo(leftImageContentView.snp.right)
            make.right.equalTo(rightImageContentView.snp.left)
            
            make.height.equalToSuperview().dividedBy(labelHeightDivisor)
        }
        
        commentImageButton.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().inset(2)
            make.bottom.equalToSuperview().inset(2)
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        
        heartImageButton.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().inset(2)
            make.bottom.equalToSuperview().inset(2)
            make.right.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        
        pinImageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview().inset(2)
        }
        
        setupImages()
        
//        titleLabel.backgroundColor = .yellow
//        descLabel.backgroundColor = .red
//        locationLabel.backgroundColor = .blue
//        leftImageContentView.backgroundColor = .purple
//        rightImageContentView.backgroundColor = .purple
        
        bottomBorder.backgroundColor = .lightGray
        
        bottomBorder.snp.makeConstraints { (make) -> Void in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().dividedBy(contentView.height * 2)
        }
    }
    
    func setupLabels() {
        titleLabel.text = "Cat Care Specialist"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.25
        titleLabel.numberOfLines = 1
        
        descLabel.text = "We are looking for cat lovers for a weekly or every other week commitment. Duties include feeding and care of cats…"
        descLabel.font = UIFont.boldSystemFont(ofSize: 30)
        descLabel.adjustsFontSizeToFitWidth = false
        descLabel.minimumScaleFactor = 0.25
        descLabel.numberOfLines = 0
        
        locationLabel.text = "Lorain County Animal Shelter"
        locationLabel.font = UIFont.boldSystemFont(ofSize: 30)
        locationLabel.adjustsFontSizeToFitWidth = true
        locationLabel.minimumScaleFactor = 0.25
        locationLabel.numberOfLines = 1
        locationLabel.baselineAdjustment = .alignCenters
    }
    
    func setupImages() {
        pinImageView.contentMode = .scaleAspectFill
        pinImageView.image = #imageLiteral(resourceName: "Pin")
        
        commentImageButton.setImage(#imageLiteral(resourceName: "Comment"), for: .normal)
        commentImageButton.imageView?.contentMode = .scaleAspectFit
        commentImageButton.addTarget(self, action: #selector(self.commentPressed), for: .touchUpInside)
        
        heartImageButton.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
        heartImageButton.setImage(#imageLiteral(resourceName: "Heart-Selected"), for: .selected)
        heartImageButton.imageView?.contentMode = .scaleAspectFit
        heartImageButton.addTarget(self, action: #selector(self.heartPressed), for: .touchUpInside)
    }
    
    func heartPressed() {
        self.heartImageButton.isSelected = !self.heartImageButton.isSelected
    }
    
    func commentPressed() {
        
    }
}

