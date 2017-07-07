//
//  CollectionCellTemplate.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 4/26/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

//import UIKit
//import Reusable
//import SnapKit
//import Font_Awesome_Swift
//
//class ListStudentCollectionCellWithAccesory: UICollectionViewCell, Reusable {
//    let itemTitleLabel = UILabel()
//    var checkmarkImage = UIImageView()
//    let leftImageContentView = UIView()
//    let rightImageContentView = UIView()
//    
//    let titleView = CircularTitleView()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        setupConstraints()
//        Stylesheet.applyOn(self)
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:)")
//    }
//    
//    func setupConstraints() {
//        self.contentView.addSubview(itemTitleLabel)
//        self.contentView.addSubview(leftImageContentView)
//        self.contentView.addSubview(rightImageContentView)
//        
//        self.leftImageContentView.addSubview(titleView)
//        self.rightImageContentView.addSubview(checkmarkImage)
//        
//        contentView.backgroundColor = .white
//        
//        checkmarkImage.contentMode = .scaleAspectFit
//        
//        itemTitleLabel.text = ""
//        itemTitleLabel.font = UIFont.boldSystemFont(ofSize: 30)
//        itemTitleLabel.adjustsFontSizeToFitWidth = true
//        itemTitleLabel.minimumScaleFactor = 0.25
//        itemTitleLabel.numberOfLines = 1
//        
//        leftImageContentView.snp.makeConstraints { (make) -> Void in
//            make.height.equalToSuperview()
//            make.width.equalTo(contentView.width / 4)
//            
//            make.left.equalToSuperview()
//            make.centerY.equalToSuperview()
//        }
//        
//        rightImageContentView.snp.makeConstraints { (make) -> Void in
//            make.height.equalToSuperview()
//            make.width.equalTo(contentView.width / 4)
//            
//            make.right.equalToSuperview()
//        }
//        
//        titleView.snp.makeConstraints { (make) -> Void in
//            make.edges.equalToSuperview()
//        }
//        
//        checkmarkImage.snp.makeConstraints { (make) -> Void in
//            make.center.equalToSuperview()
//            let inset = 5
//            make.edges.equalToSuperview().inset(inset)
//        }
//        
//        itemTitleLabel.snp.makeConstraints { (make) -> Void in
//            make.centerY.equalToSuperview()
//            make.left.equalTo(leftImageContentView.snp.right)
//            make.right.equalTo(rightImageContentView.snp.left).inset(5)
//        }
//    }
//}
