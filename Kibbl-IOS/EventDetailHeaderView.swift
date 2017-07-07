//
//  EventDetailHeaderView.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/25/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit

class EventDetailHeaderView: UIView {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let timeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.performLayout()
        Stylesheet.applyOn(self)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
    
    func performLayout() {
        let views = [
            imageView,
            titleLabel,
            dateLabel,
            timeLabel
        ]
        
        self.addSubviews(views)
        
        imageView.snp.makeConstraints{ (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(Helpers.calculateHeight(forHeight: 82))
            make.left.equalToSuperview().offset(Helpers.calculateHeight(forHeight: 30))
            make.right.equalToSuperview().inset(Helpers.calculateHeight(forHeight: 30))
//            make.height.equalTo(Helpers.calculateHeight(forHeight: 20))
        }
        
        dateLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(Helpers.calculateHeight(forHeight: 30))
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.height.equalTo(Helpers.calculateHeight(forHeight: 20))
        }
        
        timeLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(dateLabel.snp.bottom)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.height.equalTo(Helpers.calculateHeight(forHeight: 20))
        }
        
        setupLabels()
    }

    func setupLabels() {
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.minimumScaleFactor = 0.25
        titleLabel.numberOfLines = 0
        
        dateLabel.adjustsFontSizeToFitWidth = false
        dateLabel.minimumScaleFactor = 0.25
        dateLabel.numberOfLines = 1
        
        timeLabel.adjustsFontSizeToFitWidth = false
        timeLabel.minimumScaleFactor = 0.25
        timeLabel.numberOfLines = 1
    }
    
    func setupHeader(event: EventModel) {
        self.titleLabel.text = event.getName()
        self.dateLabel.text = Helpers.formatDateForStartMonthandDay(startDate: event.start_time!, endDate: event.end_time!)
        self.timeLabel.text = Helpers.formatDateForTime(startDate: event.start_time!, endDate: event.end_time!)
        
//        guard let imageURL = event.imageURL1 else { return }
//        
//        if let url = URL(string: imageURL) {
//            self.imageView.kf.indicatorType = .activity
//            self.imageView.kf.setImage(with: url)
//        }
    }
}
