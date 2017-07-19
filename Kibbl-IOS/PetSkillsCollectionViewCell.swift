//
//  PetSkillsCollectionViewCell.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/9/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable
import SnapKit
import KoalaTeaFlowLayout
import SwifterSwift

class PetSkillsCollectionViewCell: UICollectionViewCell, Reusable {
    let cellLabel = UILabel()
    let imageView = UIImageView()
    var topView = UIView()
    var bottomView = UIView()
    
    let titleView = CircularTitleView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
//        Stylesheet.applyOn(self)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    func setCellText(text: String) {
        cellLabel.text = text
    }
    
    func setupViews() {
        setupBaseViews()
        setupLabels()
        setupConstraints()
    }
    
    func setupBaseViews() {
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(topView)
        self.contentView.addSubview(bottomView)
        
        topView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().dividedBy(1.25)
        }
        
        bottomView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    func setupLabels() {
        self.bottomView.addSubview(cellLabel)
        
        cellLabel.font = UIFont.systemFont(ofSize: 14.calculateWidth())
        cellLabel.adjustsFontSizeToFitWidth = true
        cellLabel.numberOfLines = 1
        cellLabel.minimumScaleFactor = 0.25
        cellLabel.textAlignment = .center
        cellLabel.baselineAdjustment = .alignCenters
        cellLabel.lineBreakMode = .byTruncatingTail
        cellLabel.textColor = .black
    }
    
    func setupConstraints() {
        self.topView.addSubview(imageView)
        self.topView.addSubview(titleView)
        imageView.contentMode = .scaleAspectFit
        
        cellLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(4)
        }
        
        imageView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(5)
        }

        titleView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        
        titleView.titleLabel.text = ""
    }

}
