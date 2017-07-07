//
//  PetTableViewCell.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 6/21/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable
import SnapKit
import KoalaTeaFlowLayout
import SwifterSwift

class PetTableViewCell: UITableViewCell, Reusable {
    var petModel: PetModel!
    
    let titleLabel = UILabel()
    let breedLabel = UILabel()
    let descLabel = UILabel()
    let commentImageButton = UIButton()
    let heartImageButton = UIButton()
    let titleImageView = UIImageView()

    var stackView = UIStackView()
    var label1 = UILabel()
    var label2 = UILabel()
    var label3 = UILabel()
    
    var containerView = UIView()
    
    let titleViewH = 66
    let titleViewW = 66
    let titleLabelH = 25
    let titleLabelW = 140.5
    let breedLabelH = 25
    let breedLabelW = 122.5
    let descLabelH = 23.5
    let descLabelW = 261
    let stackViewH = 27.5
    let stackViewW = 154
    let commentImageButtonH = 23.5
    let commentImageButtonW = 23.5
    let heartImageButtonH = 23.5
    let heartImageButtonW = 23.5
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override func layoutSubviews() {
        performLayout()
        Stylesheet.applyOn(self)
    }
    
    func performLayout() {
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().inset(7.5.calculateHeight())
            make.bottom.equalToSuperview().inset(6.5.calculateHeight())
            make.left.equalToSuperview().inset(8.calculateWidth())
            make.right.equalToSuperview().inset(11.calculateWidth())
        }
        
        self.containerView.addSubview(titleImageView)
        titleImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        titleImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        titleImageView.widthAnchor.constraint(equalToConstant: titleViewW.calculateWidth()).isActive = true
        titleImageView.heightAnchor.constraint(equalToConstant: titleViewH.calculateHeight()).isActive = true
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        titleImageView.cornerRadius = titleViewH.calculateHeight() / 2
        
        self.containerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: titleImageView.rightAnchor, constant: 11.calculateWidth()).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: titleLabelW.calculateWidth()).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: titleLabelH.calculateHeight()).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(breedLabel)
        breedLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        breedLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        breedLabel.widthAnchor.constraint(equalToConstant: breedLabelW.calculateWidth()).isActive = true
        breedLabel.heightAnchor.constraint(equalToConstant: breedLabelH.calculateHeight()).isActive = true
        breedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        descLabel.leftAnchor.constraint(equalTo: titleImageView.rightAnchor, constant: 11.calculateWidth()).isActive = true
        descLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        descLabel.heightAnchor.constraint(equalToConstant: descLabelH.calculateHeight()).isActive = true
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(stackView)
        stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: titleImageView.rightAnchor, constant: 11.calculateWidth()).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: stackViewW.calculateWidth()).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: stackViewH.calculateHeight()).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(heartImageButton)
        heartImageButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        heartImageButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        heartImageButton.widthAnchor.constraint(equalToConstant: heartImageButtonW.calculateWidth()).isActive = true
        heartImageButton.heightAnchor.constraint(equalToConstant: heartImageButtonH.calculateHeight()).isActive = true
        heartImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(commentImageButton)
        commentImageButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        commentImageButton.rightAnchor.constraint(equalTo: heartImageButton.leftAnchor, constant: -25.calculateWidth()).isActive = true
        commentImageButton.widthAnchor.constraint(equalToConstant: heartImageButtonW.calculateWidth()).isActive = true
        commentImageButton.heightAnchor.constraint(equalToConstant: heartImageButtonH.calculateHeight()).isActive = true
        commentImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        setupLabels()
        setupImages()
        setupStackView()
    }
    
    func setupLabels() {
//        titleLabel.text = "Ruby"
        titleLabel.font = UIFont.systemFont(ofSize: 30)
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.minimumScaleFactor = 0.25
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        breedLabel.textAlignment = .left
        titleLabel.baselineAdjustment = .alignCenters
        
//        breedLabel.text = "Pug/Pomeranian Mix"
        breedLabel.font = UIFont.systemFont(ofSize: 20)
        breedLabel.adjustsFontSizeToFitWidth = false
        breedLabel.minimumScaleFactor = 0.25
        breedLabel.numberOfLines = 1
        breedLabel.lineBreakMode = .byTruncatingTail
        breedLabel.textAlignment = .right
        breedLabel.baselineAdjustment = .alignCenters
        
//        descLabel.text = "Spunky little pug puppy that will follow you..."
        descLabel.font = UIFont.boldSystemFont(ofSize: 30)
        descLabel.adjustsFontSizeToFitWidth = false
        descLabel.minimumScaleFactor = 0.25
        descLabel.numberOfLines = 1
        descLabel.lineBreakMode = .byTruncatingTail
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
    
    func setupStackView() {
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        
        label1.font = UIFont.systemFont(ofSize: 14)
        label1.textAlignment = .center
        label1.textColor = UIColor(hex: 0x95928E)
        label1.backgroundColor = UIColor(hex: 0xF9F9F9)
        
        label2.font = UIFont.systemFont(ofSize: 14)
        label2.textAlignment = .center
        label2.textColor = UIColor(hex: 0x95928E)
        label2.backgroundColor = UIColor(hex: 0xF9F9F9)
        
        label3.font = UIFont.systemFont(ofSize: 14)
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
        
        self.setImage(imageURL: model.thumbURL1)
        
        heartImageButton.isSelected = model.favorited
    }
    
    func formatSize(size: String) -> String {
        guard size != "" else { return "" }
        return String(describing: Float(size)!.rounded()).replacingOccurrences(of: ".0", with: "lbs")
    }
    
    func setImage(imageURL: String?) {
        guard let url = imageURL else {
            self.titleImageView.image = #imageLiteral(resourceName: "JustKibblDog")
            self.titleImageView.contentMode = .scaleAspectFit
            self.titleImageView.backgroundColor = Stylesheet.Colors.base
            return
        }
        if let imageURL = URL(string: url) {
            self.titleImageView.kf.indicatorType = .activity
            self.titleImageView.kf.setImage(with: imageURL)
            self.titleImageView.contentMode = .scaleAspectFill
            self.titleImageView.backgroundColor = .clear
        }
    }
}
