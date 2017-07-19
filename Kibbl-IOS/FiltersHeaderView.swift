//
//  FiltersTopView.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 4/26/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

//import UIKit
//import SnapKit
//import FittableFontLabel
//
//class FiltersHeaderView: UIView {
//    
//    var greenColor = UIColor()
//    var grayColor = UIColor()
//    
//    var completedButton = UIButton()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame);
//        
//        self.performLayout()
//        
//        return;
//    }
//    
//    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
//    
//    func performLayout() {
//        self.addSubview(completedButton)
//        
//        completedButton.setTitle("Not Completed", for: .normal)
//        completedButton.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
//        
//        completedButton.snp.makeConstraints { (make) -> Void in
//            make.edges.equalToSuperview()
//        }
//        
////        Stylesheet.applyOn(self)
//    }
//    
//    func setupButtonState() {
////        if wholeGroupLesson != nil {
////            switch wholeGroupLesson.completed {
////            case true:
////                completedButton.backgroundColor = greenColor
////                completedButton.setTitle("Completed", for: .normal)
////            default: // false
////                completedButton.backgroundColor = grayColor
////                completedButton.setTitle("Not Completed", for: .normal)
////            }
////            
////            return
////        }
////        
////        completedButton.backgroundColor = greenColor
////        completedButton.setTitle("Complete For This Group", for: .normal)
//    }
//    
//    func buttonPressed() {
//        setupButtonState()
//    }
//    
//}

import UIKit
import SnapKit
import Reusable

class FilterHeaderView: UIView {
    
    var fromViewController: UIViewController!
    
    var filterButton = UIButton()
    var buttonStackView = UIStackView()
    var filterButtonLabel = LabelWithAdaptiveTextHeight()
    var filterButtonImageView = UIImageView()
    
    var activeColor = UIColor()
    var disabledColor = UIColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    convenience init(frame: CGRect, fromViewController: UIViewController) {
        self.init(frame: frame);
        
        self.fromViewController = fromViewController
        self.performLayout()
//        Stylesheet.applyOn(self)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
    
    func performLayout() {
        self.addSubview(filterButton)
        self.filterButton.addSubview(buttonStackView)
        self.buttonStackView.addArrangedSubview(filterButtonImageView)
        self.buttonStackView.addArrangedSubview(filterButtonLabel)
        
        filterButton.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
        filterButton.setTitleColor(.lightGray, for: .normal)
        filterButton.setTitleColor(Stylesheet.Colors.white, for: .selected)
        filterButton.setBackgroundColor(color: Stylesheet.Colors.clear, forState: .normal)
        filterButton.setBackgroundColor(color: Stylesheet.Colors.base, forState: .selected)
        
        filterButton.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview().inset(20)
        }
        
        filterButton.layer.borderWidth = 1
        filterButton.layer.borderColor  = UIColor.lightGray.cgColor
        filterButton.cornerRadius = 6
        
        self.backgroundColor = .white
        
        setupStackView()
        checkIsSelected()
    }
    
    func buttonPressed() {
        self.filterButton.isSelected = !self.filterButton.isSelected
        checkIsSelected()
        
        var vc = UIViewController()
        
        switch fromViewController {
        case is SheltersCollectionViewController:
            vc = ShelterFilterFormViewController()
        default: // PetCollectionView
            vc = PetFilterFormViewController()
        }
        
        
        let navVC = UINavigationController(rootViewController: vc)
        fromViewController.present(navVC, animated: true, completion: nil)
    }
    
    func setupStackView() {
        buttonStackView.alignment = .center
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillProportionally
        
        buttonStackView.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        }
        
        filterButtonLabel.text = "Filters"
        
        filterButtonImageView.image = #imageLiteral(resourceName: "Filter")
        filterButtonImageView.contentMode = .scaleAspectFit
        
        filterButtonLabel.isUserInteractionEnabled = false
        filterButtonImageView.isUserInteractionEnabled = false
        buttonStackView.isUserInteractionEnabled = false
    }
    
    func checkIsSelected() {
        switch filterButton.isSelected {
        case false:
            filterButtonLabel.textColor = .lightGray
            filterButtonImageView.image = filterButtonImageView.image?.maskWithColor(color: .lightGray)
        default:
            filterButtonLabel.textColor = Stylesheet.Colors.white
            filterButtonImageView.image = filterButtonImageView.image?.maskWithColor(color: Stylesheet.Colors.white)
        }
    }
}

class FilterHeaderCollectionReusableView: UICollectionReusableView, Reusable {
    
    var fromViewController: UIViewController!
    
    var buttonStackView = UIStackView()
    var filterButtonLabel = LabelWithAdaptiveTextHeight()
    var filterButtonImageView = UIImageView()
    
    var activeColor = UIColor()
    var disabledColor = UIColor()
    
    var filterButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.performLayout()
        //        Stylesheet.applyOn(self)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
    
    func performLayout() {
        self.addSubview(filterButton)
        self.filterButton.addSubview(buttonStackView)
        self.buttonStackView.addArrangedSubview(filterButtonImageView)
        self.buttonStackView.addArrangedSubview(filterButtonLabel)
        
        filterButton.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
        filterButton.setBackgroundColor(color: Stylesheet.Colors.clear, forState: .normal)
        filterButton.setBackgroundColor(color: Stylesheet.Colors.base, forState: .selected)
        
        filterButton.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalToSuperview().inset(20.calculateHeight())
            make.left.right.equalToSuperview().inset(20.calculateWidth())
        }
        
        filterButton.layer.borderWidth = 1
        filterButton.layer.borderColor  = UIColor.lightGray.cgColor
        filterButton.cornerRadius = 6
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkIsSelected), name: .filterChanged, object: nil)
        
        self.backgroundColor = .white
        
        setupStackView()
        checkIsSelected()
    }
    
    func buttonPressed() {
        checkIsSelected()
        
        var vc = UIViewController()
        
        switch fromViewController {
        case is EventsCollectionViewController:
            vc = EventFilterFormViewController()
        case is SheltersCollectionViewController:
            vc = ShelterFilterFormViewController()
        default: // PetCollectionView
            vc = PetFilterFormViewController()
        }
        
        let navVC = UINavigationController(rootViewController: vc)
        fromViewController.present(navVC, animated: true, completion: nil)
    }
    
    func setupStackView() {
        buttonStackView.alignment = .center
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillProportionally
        
        buttonStackView.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        }
        
        filterButtonLabel.text = "Filters"
        
        filterButtonImageView.image = #imageLiteral(resourceName: "Filter")
        filterButtonImageView.contentMode = .scaleAspectFit
        
        filterButtonLabel.isUserInteractionEnabled = false
        filterButtonImageView.isUserInteractionEnabled = false
        buttonStackView.isUserInteractionEnabled = false
    }
    
    func checkIsSelected() {
        //@TODO: check active for seperate fromviewcontroller
        let filterActive = FilterModel.isAnyActiveFilter()
        filterButton.isSelected = filterActive
        
        switch filterButton.isSelected {
        case false:
            filterButtonLabel.textColor = .lightGray
            filterButtonImageView.image = filterButtonImageView.image?.maskWithColor(color: .lightGray)
        default:
            filterButtonLabel.textColor = Stylesheet.Colors.white
            filterButtonImageView.image = filterButtonImageView.image?.maskWithColor(color: Stylesheet.Colors.white)
        }
    }
}

