//
//  EventsCollectionViewCell.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 4/27/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable
import SnapKit

class EventsCollectionViewCell: UICollectionViewCell, Reusable {
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let locationLabel = UILabel()
    let commentImageButton = UIButton()
    let heartImageButton = UIButton()
    
    let leftImageContentView = UIView()
    let rightImageContentView = UIView()
    
    let labelContentView = UIView()
    
    let titleView = CircularTitleView()
    var eventModel: EventModel!
    
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
        self.labelContentView.addSubview(dateLabel)
        self.labelContentView.addSubview(locationLabel)
        self.labelContentView.addSubview(rightImageContentView)
        self.rightImageContentView.addSubview(commentImageButton)
        self.rightImageContentView.addSubview(heartImageButton)
        
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
        
        dateLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(leftImageContentView.snp.right)
            make.right.equalToSuperview()
            
            make.height.equalToSuperview().dividedBy(3.5)
        }
        
        locationLabel.snp.makeConstraints { (make) -> Void in
            make.bottom.equalToSuperview()
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

        setupImages()
    }
    
    func setupLabels() {
        titleLabel.text = "Pets n More Adoption Drive"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.minimumScaleFactor = 0.25
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        
        dateLabel.text = "March 28—31, 10:00 AM—5:00 PM"
        dateLabel.font = UIFont.boldSystemFont(ofSize: 30)
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 0.25
        dateLabel.numberOfLines = 1
        
        locationLabel.text = "Baton Rouge, LA"
        locationLabel.font = UIFont.boldSystemFont(ofSize: 30)
        locationLabel.adjustsFontSizeToFitWidth = true
        locationLabel.minimumScaleFactor = 0.25
        locationLabel.numberOfLines = 1
    }
    
    func setupImages() {
        commentImageButton.setImage(#imageLiteral(resourceName: "Comment"), for: .normal)
        commentImageButton.imageView?.contentMode = .scaleAspectFit
        commentImageButton.addTarget(self, action: #selector(self.commentPressed), for: .touchUpInside)
        
        heartImageButton.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
        heartImageButton.setImage(#imageLiteral(resourceName: "Heart-Selected"), for: .selected)
        heartImageButton.imageView?.contentMode = .scaleAspectFit
        heartImageButton.addTarget(self, action: #selector(self.heartPressed), for: .touchUpInside)
    }
    
    func heartPressed() {
        guard User.checkAndAlert() else { return }
        guard eventModel != nil else { return }
        eventModel.switchFavorite()
        
        self.heartImageButton.isSelected = !self.heartImageButton.isSelected
    }
    
    func commentPressed() {
        
    }
    
    func setupCell(model: EventModel) {
        self.eventModel = model
        titleLabel.text = model.name
        dateLabel.text = Helpers.formatDateForFull(startDate: model.start_time!, endDate: model.end_time!)
        
        locationLabel.text = model.getCityState()
        
        titleView.titleLabel.text = model.getEventTimeDay() + "\n" + model.getEventTimeMonthName()
        heartImageButton.isSelected = model.favorited
        Stylesheet.applyOn(self)

    }
}
