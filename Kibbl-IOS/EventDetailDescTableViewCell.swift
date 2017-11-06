//
//  EventDetailDescTableViewCell.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/11/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable
import SnapKit
import SwifterSwift

class EventDetailDescTableViewCell: UITableViewCell, Reusable {
    let containerView = UIView()
    let titleLabel = UILabel()
    let descLabel = UILabel()
    
    let contactButton = UIButton()
    var buttonStackView = UIStackView()
    var contactButtonLabel = LabelWithAdaptiveTextHeight()
    var contactButtonImageView = UIImageView()
    var followButton = UIButton()
    
    var eventModel: EventModel!
    var shelterModel: ShelterModel!
    
    var viewPetsButton = UIButton()
    var viewEventsButton = UIButton()
    var viewShelterButton = UIButton()
    var subscribeToShelterButton = UIButton()
    var fromVC: UIViewController!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(containerView)
        
        let views = [
            titleLabel,
            descLabel,
            ]
        
        self.containerView.addSubview(viewPetsButton)
        self.containerView.addSubview(viewEventsButton)
        self.containerView.addSubview(subscribeToShelterButton)
        self.containerView.addSubview(followButton)
        self.containerView.addSubviews(views)
        self.containerView.addSubview(contactButton)
        
        setupConstraints()
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
        
        followButton.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview()
            make.width.equalTo(90.calculateWidth())
            make.height.equalTo(36.calculateHeight())
        }
        
        viewPetsButton.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview()
            make.width.equalTo(120.calculateWidth())
            make.height.equalTo(36.calculateHeight())
        }
        
        viewEventsButton.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(viewPetsButton.snp.right).inset(-10.calculateWidth())
            make.width.equalTo(120.calculateWidth())
            make.height.equalTo(36.calculateHeight())
        }
        
        viewPetsButton.setTitle("View Pets", for: .normal)
        viewPetsButton.setBackgroundColor(color: Stylesheet.Colors.base, forState: .normal)
        viewPetsButton.addTarget(self, action: #selector(self.viewPetsButtonPressed), for: .touchUpInside)
        viewPetsButton.cornerRadius = 8.calculateHeight()
        
        viewEventsButton.setTitle("View Events", for: .normal)
        viewEventsButton.setBackgroundColor(color: Stylesheet.Colors.base, forState: .normal)
        viewEventsButton.addTarget(self, action: #selector(self.viewEventsButtonPressed), for: .touchUpInside)
        viewEventsButton.cornerRadius = 8.calculateHeight()
        
        self.containerView.addSubview(viewShelterButton)
        
        viewShelterButton.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview()
            make.width.equalTo(120.calculateWidth())
            make.height.equalTo(36.calculateHeight())
        }
        
        viewShelterButton.setTitle("View Shelter", for: .normal)
        viewShelterButton.setBackgroundColor(color: Stylesheet.Colors.base, forState: .normal)
        viewShelterButton.addTarget(self, action: #selector(self.viewSheltersButtonPressed), for: .touchUpInside)
        viewShelterButton.cornerRadius = 8.calculateHeight()
        viewShelterButton.isHidden = true
        
        subscribeToShelterButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(viewShelterButton.snp.bottom).offset(10.calculateHeight())
            make.left.equalToSuperview()
            make.width.equalTo(220.calculateWidth())
            make.height.equalTo(36.calculateHeight())
        }
        
        subscribeToShelterButton.setTitle("Subscribe to shelter", for: .normal)
        subscribeToShelterButton.setTitle("Unsubscribe from shelter", for: .selected)
        subscribeToShelterButton.setBackgroundColor(color: Stylesheet.Colors.base, forState: .normal)
        subscribeToShelterButton.setBackgroundColor(color: Stylesheet.Colors.gray, forState: .selected)
        subscribeToShelterButton.addTarget(self, action: #selector(self.subscribeToShelterButtonPressed), for: .touchUpInside)
        subscribeToShelterButton.cornerRadius = 8.calculateHeight()
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(subscribeToShelterButton.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(36.calculateHeight())
        }
        
        descLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }

        contactButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(descLabel.snp.bottom).offset(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            
            make.height.equalTo(Helpers.calculateHeight(forHeight: 36))
        }

        setupLabels()
        setupButton()
        setupFollowButton()
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalToSuperview().inset(13)
            make.bottom.equalTo(contactButton).offset(23)
        }
    }
    
    func setupFollowButton() {
        followButton.setTitle("Favorite", for: .normal)
        followButton.setTitle("Unfavorite", for: .selected)
        followButton.setBackgroundColor(color: Stylesheet.Colors.base, forState: .normal)
        followButton.setBackgroundColor(color: Stylesheet.Colors.gray, forState: .selected)
        
        followButton.cornerRadius = 8.calculateHeight()
        
        followButton.addTarget(self, action: #selector(self.followButtonPressed), for: .touchUpInside)
    }
    
    func followButtonPressed() {
        guard User.checkAndAlert() else { return }
        guard eventModel != nil || shelterModel != nil else { return }
        
        if eventModel != nil {
            eventModel.switchFavorite()
        }
        
        if shelterModel != nil && eventModel == nil {
            shelterModel.subscribeCall()
        }
        
        self.followButton.isSelected = !self.followButton.isSelected
    }
    
    func setupButton() {
        self.contactButton.addSubview(buttonStackView)
        self.buttonStackView.addArrangedSubview(contactButtonImageView)
        self.buttonStackView.addArrangedSubview(contactButtonLabel)
        
        contactButton.addTarget(self, action: #selector(self.contactButtonPressed), for: .touchUpInside)
        contactButton.setTitleColor(.lightGray, for: .normal)
        contactButton.setBackgroundColor(color: Stylesheet.Colors.offWhite, forState: .normal)
        
        contactButton.cornerRadius = 6
        
        buttonStackView.alignment = .center
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillProportionally
        
        buttonStackView.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        }
        
        contactButtonLabel.text = "Website"
        contactButtonLabel.textColor = .lightGray
        
        contactButtonImageView.image = #imageLiteral(resourceName: "Mail")
        contactButtonImageView.contentMode = .scaleAspectFit
        
        contactButtonLabel.isUserInteractionEnabled = false
        contactButtonImageView.isUserInteractionEnabled = false
        buttonStackView.isUserInteractionEnabled = false
    }
    
    func contactButtonPressed() {
        var urlToOpen: URL!
        
        if eventModel != nil {
            guard let url = eventModel.getWebsite() else { return }
            urlToOpen = url
        }
        
        if shelterModel != nil {
            guard let url = shelterModel.getWebsite() else { return }
            urlToOpen = url
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(urlToOpen, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(urlToOpen)
        }
    }
    
    func setupLabels() {
        descLabel.adjustsFontSizeToFitWidth = false
        descLabel.minimumScaleFactor = 0.25
        descLabel.numberOfLines = 0
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.25
        titleLabel.numberOfLines = 1
    }
    
    
    func setupCell(event item: EventModel) {
        self.shelterModel = item.connectedShelter
        self.eventModel = item
        self.descLabel.text = item.getDescription()
        followButton.isSelected = item.favorited
        
        viewShelterButton.isHidden = false
        viewEventsButton.isHidden = true
        viewPetsButton.isHidden = true
        
        if shelterModel == nil {
            self.viewShelterButton.isHidden = true
            self.subscribeToShelterButton.isHidden = true
        }
        
        // Set subscribe button selected
        if shelterModel != nil {
            subscribeToShelterButton.isSelected = shelterModel.following
        }
    }
    
    func setupCell(shelter item: ShelterModel) {
        self.shelterModel = item
        self.titleLabel.text = item.getName()
        self.descLabel.text = item.getDescription()
        
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitle("Unfollow", for: .selected)
        followButton.isSelected = item.following
        
        self.subscribeToShelterButton.isHidden = true
    }
    
    func viewPetsButtonPressed() {
        guard let fromVC = fromVC else { return }
        let vc = ViewPetsCollectionViewController(collectionViewLayout: UICollectionViewLayout())
        vc.shelterId = self.shelterModel.key!
        fromVC.navigationController?.pushViewController(vc)
    }
    
    func viewEventsButtonPressed() {
        guard let fromVC = fromVC else { return }
        let vc = ViewEventsCollectionViewController(collectionViewLayout: UICollectionViewLayout())
        vc.shelterId = self.shelterModel.key!
        fromVC.navigationController?.pushViewController(vc)
    }
    
    func viewSheltersButtonPressed() {
        guard let fromVC = fromVC else { return }
        guard shelterModel != nil else { return }
        
        let vc = ShelterDetailTableViewController()
        vc.shelter = self.shelterModel
        fromVC.navigationController?.pushViewController(vc)
    }
    
    func subscribeToShelterButtonPressed() {
        guard shelterModel != nil else { return }
        
        shelterModel.subscribeCall()
        self.subscribeToShelterButton.isSelected = !self.subscribeToShelterButton.isSelected
    }
}
