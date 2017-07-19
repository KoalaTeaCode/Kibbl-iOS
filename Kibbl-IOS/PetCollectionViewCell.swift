//
//  PetCollectionViewCell.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 4/29/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable
import SnapKit
import KoalaTeaFlowLayout
import SwifterSwift

class PetCollectionViewCell: UICollectionViewCell, Reusable {
    let titleLabel = UILabel()
    let breedLabel = UILabel()
    let descLabel = UILabel()
    let tagContainerView = UIView()
    let commentImageButton = UIButton()
    let heartImageButton = UIButton()
    
    let leftImageContentView = UIView()
    let rightImageContentView = UIView()
    
    let labelContentView = UIView()
    
    let titleView = ImageCircularView()
    
    var petModel: PetModel!
    
    var stackView = UIStackView()
    var label1 = UILabel()
    var label2 = UILabel()
    var label3 = UILabel()
    
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
        self.labelContentView.addSubview(breedLabel)
        self.labelContentView.addSubview(descLabel)
        self.labelContentView.addSubview(tagContainerView)
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
            make.width.equalToSuperview().dividedBy(2)

            make.height.equalToSuperview().dividedBy(3.25)
        }
        
        breedLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).inset(2)
            make.right.equalToSuperview().inset(20)
//            make.width.equalToSuperview().dividedBy(2)
            
            make.height.equalToSuperview().dividedBy(3.25)
        }
        
        descLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(leftImageContentView.snp.right)
            make.right.equalToSuperview().inset(20)
            
            make.height.equalToSuperview().dividedBy(3.5)
        }
        
        tagContainerView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalToSuperview()
            make.left.equalTo(leftImageContentView.snp.right)
            make.right.equalTo(rightImageContentView.snp.left).inset(-20)
            
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
        
        setupStackView()
    }
    
    func setupLabels() {
        titleLabel.text = "Ruby"
        titleLabel.font = UIFont.systemFont(ofSize: 30.calculateWidth())
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.minimumScaleFactor = 0.25
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        breedLabel.textAlignment = .left
        titleLabel.baselineAdjustment = .alignCenters
        
        breedLabel.text = "Pug/Pomeranian Mix"
        breedLabel.font = UIFont.systemFont(ofSize: 20.calculateWidth())
        breedLabel.adjustsFontSizeToFitWidth = false
        breedLabel.minimumScaleFactor = 0.25
        breedLabel.numberOfLines = 1
        breedLabel.lineBreakMode = .byTruncatingTail
        breedLabel.textAlignment = .right
        breedLabel.baselineAdjustment = .alignCenters
        
        descLabel.text = "Spunky little pug puppy that will follow you…"
        descLabel.font = UIFont.boldSystemFont(ofSize: 30.calculateWidth())
        descLabel.adjustsFontSizeToFitWidth = false
        descLabel.minimumScaleFactor = 0.25
        descLabel.numberOfLines = 1
        descLabel.lineBreakMode = .byTruncatingTail
    }
    
    func setupImages() {
//        commentImageButton.setImage(#imageLiteral(resourceName: "Comment"), for: .normal)
        commentImageButton.imageView?.contentMode = .scaleAspectFit
        commentImageButton.addTarget(self, action: #selector(self.commentPressed), for: .touchUpInside)
        
        heartImageButton.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
        heartImageButton.setImage(#imageLiteral(resourceName: "Heart-Selected"), for: .selected)
        heartImageButton.imageView?.contentMode = .scaleAspectFit
        heartImageButton.addTarget(self, action: #selector(self.heartPressed), for: .touchUpInside)
    }
    
    func setupStackView() {
        self.tagContainerView.addSubview(stackView)
        
        stackView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        
        label1.font = UIFont.systemFont(ofSize: 14.calculateWidth())
        label1.textAlignment = .center
        label1.textColor = UIColor(hex: 0x95928E)
        label1.backgroundColor = UIColor(hex: 0xF9F9F9)
        
        label2.font = UIFont.systemFont(ofSize: 14.calculateWidth())
        label2.textAlignment = .center
        label2.textColor = UIColor(hex: 0x95928E)
        label2.backgroundColor = UIColor(hex: 0xF9F9F9)
        
        label3.font = UIFont.systemFont(ofSize: 14.calculateWidth())
        label3.textAlignment = .center
        label3.textColor = UIColor(hex: 0x95928E)
        label3.backgroundColor = UIColor(hex: 0xF9F9F9)
        
        stackView.addArrangedSubview(label1)
        stackView.addArrangedSubview(label2)
        stackView.addArrangedSubview(label3)
    }
    
    func setupStackViewLabels(model: PetModel) {
        let height = Helpers.calculateHeight(forHeight: 27.5) / 2
        label1.cornerRadius = height
        label2.cornerRadius = height
        label3.cornerRadius = height

        if let age = model.age, model.age != "" {
            label1.text = age
        }
        
        if let sex = model.sex {
            label2.text = sex
        }
        
        let size = formatSize(size: model.size!)
        label3.text = size
        if size == "0lbs" {
            label3.text = ""
        }
        
    }
    
    func heartPressed() {
        guard User.checkAndAlert() else { return }
        guard petModel != nil else { return }
        petModel.switchFavorite()
        
        self.heartImageButton.isSelected = !self.heartImageButton.isSelected
    }
    
    func commentPressed() {
        
    }
    
    func setupCell(model: PetModel) {
        self.petModel = model
        
        setupStackViewLabels(model: model)
        titleLabel.text = model.name
        descLabel.text = model.getDescription()
        breedLabel.text = model.breed1
        
        titleView.setImage(imageURL: model.thumbURL1)
        
        heartImageButton.isSelected = model.favorited
    }
    
    func formatSize(size: String) -> String {
        guard size != "" else { return "" }
        return String(describing: Float(size)!.rounded()).replacingOccurrences(of: ".0", with: "lbs")
    }
}
