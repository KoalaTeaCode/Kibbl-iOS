//
//  Stylesheet.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 4/26/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//
import UIKit
import SwifterSwift
import UIFontComplete

// MARK: - Stylesheet
enum Stylesheet {
    
    enum Colors {
        static let white = UIColor(hex: 0xFFFFFF)
        static let gray = UIColor(hex: 0xD6D4D2)
        static let offBlack = UIColor(hex: 0x262626)
        static let offWhite = UIColor(hex: 0xF9F9F9)
        static let clear = UIColor.clear
        
        static let blackText = UIColor(hex: 0x36322E)
        static let grayText = UIColor(hex: 0x979390)
        
        static let base = UIColor(hex: 0xFF9933)
        static let light1 = UIColor(hex: 0xFFC082)
        static let light2 = UIColor(hex: 0xFFAB58)
        static let dark1 = UIColor(hex: 0xE77607)
        static let dark2 = UIColor(hex: 0xB25800)
    }
    
    enum Fonts {
        static let Regular = Font.helveticaNeue
        static let Bold = Font.helveticaNeueBold
    }
    
    enum Contexts {
        enum Global {
            static let StatusBarStyle = UIStatusBarStyle.lightContent
            static let StatusBarBackgroundColor = Colors.base
        }
        
        enum NavigationController {
            static let BarTintColor = Colors.base
            static let BarColor = Colors.white
        }
        
        enum EventHeader {
            static let BackgroundColor = Colors.light2
            static let TextColor = Colors.white
        }
    }
    
    enum CellContexts {
        enum EventsCell {
            static let titleTextColor = Colors.blackText
            static let detailTextColor = Colors.grayText
            static let heartTintColor = Colors.gray
            static let followTintColor = Colors.base
            static let unfollowTintColor = Colors.gray
        }
    }
    
}

// MARK: - Apply Stylesheet
extension Stylesheet {
    static func applyOn(_ navVC: UINavigationController) {
        typealias context = Contexts.NavigationController
        
        let navBar = navVC.navigationBar
        
        navBar.isTranslucent = false
        navBar.setColors(background: context.BarColor, text: context.BarTintColor)
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        
        UIApplication.shared.statusBarView?.backgroundColor = Contexts.Global.StatusBarBackgroundColor
    }
    
    static func applyOn(_ view: CircularTitleView) {
        view.titleLabel.textColor = Colors.white
        view.titleLabel.font = UIFont(font: Fonts.Bold, size: 30.calculateWidth())
        
        view.labelView.backgroundColor = Colors.base
    }
}

extension Stylesheet {
    // Cells
    
    static func applyOn(_ cell: EventsCollectionViewCell) {
        typealias context = CellContexts.EventsCell
        cell.titleLabel.textColor = context.titleTextColor
        cell.dateLabel.textColor = context.detailTextColor
        cell.locationLabel.textColor = context.detailTextColor
        
        cell.titleLabel.font = UIFont(font: Fonts.Regular, size: 16.calculateWidth())
        cell.dateLabel.font = UIFont(font: Fonts.Regular, size: 12.calculateWidth())
        cell.locationLabel.font = UIFont(font: Fonts.Regular, size: 12.calculateWidth())
        
        cell.heartImageButton.tintColor = context.heartTintColor
    }
    
    static func applyOn(_ cell: EventTableViewCell) {
        typealias context = CellContexts.EventsCell
        cell.titleLabel.textColor = context.titleTextColor
        cell.dateLabel.textColor = context.detailTextColor
        cell.locationLabel.textColor = context.detailTextColor
        
        cell.titleLabel.font = UIFont(font: Fonts.Regular, size: 16.calculateWidth())
        cell.dateLabel.font = UIFont(font: Fonts.Regular, size: 12.calculateWidth())
        cell.locationLabel.font = UIFont(font: Fonts.Regular, size: 12.calculateWidth())
        
        cell.heartImageButton.tintColor = context.heartTintColor
    }
    
    static func applyOn(_ cell: ShelterCollectionViewCell) {
        typealias context = CellContexts.EventsCell
        cell.titleLabel.textColor = context.titleTextColor
        cell.dateLabel.textColor = context.detailTextColor
        cell.locationLabel.textColor = context.detailTextColor
        
        cell.titleLabel.font = UIFont(font: Fonts.Regular, size: 16.calculateWidth())
        cell.dateLabel.font = UIFont(font: Fonts.Regular, size: 12.calculateWidth())
        cell.locationLabel.font = UIFont(font: Fonts.Regular, size: 12.calculateWidth())
        
//        cell.heartImageButton.tintColor = context.heartTintColor
        cell.followButton.setTitleColor(context.followTintColor, for: .normal)
        cell.followButton.setTitleColor(context.unfollowTintColor, for: .selected)
    }
    
    static func applyOn(_ cell: UpdatesCollectionViewCell) {
        typealias context = CellContexts.EventsCell
        cell.titleLabel.textColor = context.titleTextColor
        cell.dateLabel.textColor = context.detailTextColor
        cell.locationLabel.textColor = context.detailTextColor
        
        cell.titleLabel.font = UIFont(font: Fonts.Regular, size: 16.calculateWidth())
        cell.descLabel.font = UIFont(font: Fonts.Regular, size: 12.calculateWidth())
        cell.locationLabel.font = UIFont(font: Fonts.Regular, size: 12.calculateWidth())
//        cell.dateLabel.font = UIFont(font: Fonts.Regular, size: 12)
    }
    
    static func applyOn(_ cell: VolunteerCollectionViewCell) {
        typealias context = CellContexts.EventsCell
        cell.titleLabel.textColor = context.titleTextColor
        cell.descLabel.textColor = context.detailTextColor
        cell.locationLabel.textColor = context.detailTextColor
        
        cell.titleLabel.font = UIFont(font: Fonts.Regular, size: 16.calculateWidth())
        cell.descLabel.font = UIFont(font: Fonts.Regular, size: 12.calculateWidth())
        cell.locationLabel.font = UIFont(font: Fonts.Regular, size: 12.calculateWidth())
        
        cell.heartImageButton.tintColor = context.heartTintColor
    }
    
    static func applyOn(_ cell: PetCollectionViewCell) {
        typealias context = CellContexts.EventsCell
        cell.titleLabel.textColor = context.titleTextColor
        cell.descLabel.textColor = context.detailTextColor
        
        cell.titleLabel.font = UIFont(font: Fonts.Regular, size: 16.calculateWidth())
        cell.descLabel.font = UIFont(font: Fonts.Regular, size: 12.calculateWidth())
        cell.breedLabel.font = UIFont(font: Fonts.Regular, size: 12.calculateWidth())
        
        cell.heartImageButton.tintColor = context.heartTintColor
    }
    
    static func applyOn(_ cell: PetTableViewCell) {
        typealias context = CellContexts.EventsCell
        cell.titleLabel.textColor = context.titleTextColor
        cell.descLabel.textColor = context.detailTextColor
        
        cell.titleLabel.font = UIFont(font: Fonts.Regular, size: 16.calculateWidth())
        cell.descLabel.font = UIFont(font: Fonts.Regular, size: 12.calculateWidth())
        cell.breedLabel.font = UIFont(font: Fonts.Regular, size: 12.calculateWidth())
        
        cell.heartImageButton.tintColor = context.heartTintColor
    }
    
    static func applyOn(_ cell: EventDetailDescTableViewCell) {
        typealias context = CellContexts.EventsCell
        
        cell.titleLabel.font = UIFont(font: Fonts.Regular, size: 20.calculateWidth())
        cell.descLabel.font = UIFont(font: Fonts.Regular, size: 14.calculateWidth())
    }
    
    static func applyOn(_ cell: PetDetailDescTableViewCell) {
        typealias context = CellContexts.EventsCell
        
        cell.titleLabel.font = UIFont(font: Fonts.Regular, size: 21.calculateWidth())
        cell.descLabel.font = UIFont(font: Fonts.Regular, size: 14.calculateWidth())
        cell.ageDescLabel.font = UIFont(font: Fonts.Regular, size: 16.calculateWidth())
        // Needs to be medium
        cell.ageLabel.font = UIFont(font: Fonts.Regular, size: 12.calculateWidth())
        cell.breedDescLabel.font = UIFont(font: Fonts.Regular, size: 16.calculateWidth())
        // Needs to be medium
        cell.breedLabel.font = UIFont(font: Fonts.Regular, size: 12.calculateWidth())
    }
    
    static func applyOn(_ cell: LocationTableViewCell) {
        typealias context = CellContexts.EventsCell
        
        cell.locationNameLabel.font = UIFont(font: Fonts.Regular, size: 16.calculateWidth())
        cell.locationAddressLabel.font = UIFont(font: Fonts.Regular, size: 14.calculateWidth())
        cell.locationPhoneLabel.font = UIFont(font: Fonts.Regular, size: 14.calculateWidth())
        cell.locationEmailLabel.font = UIFont(font: Fonts.Regular, size: 14.calculateWidth())
    }
    
    static func applyOn(_ cell: AddressTableViewCell) {
        typealias context = CellContexts.EventsCell
        
        cell.locationNameLabel.font = UIFont(font: Fonts.Regular, size: 16.calculateWidth())
        cell.locationAddressLabel.font = UIFont(font: Fonts.Regular, size: 14.calculateWidth())
    }
    
    static func applyOn(_ viewController: ContainerViewController) {
//        typealias context = Contexts.AddGroupTable
        
        let segmentControl = viewController.layoutSegmentControl
        
        segmentControl.titleFont = UIFont(name: "HelveticaNeue", size: 14.0.calculateWidth())!
        segmentControl.selectedTitleFont = UIFont(name: "HelveticaNeue-Medium", size: 14.0.calculateWidth())!
        
        segmentControl.selectedTitleColor = Colors.white
        segmentControl.titleColor = Colors.offBlack
        segmentControl.indicatorViewBackgroundColor = Colors.dark1
        
        let segmentHeight = viewController.topBarHeight / 2
        
        let cornerRadius = segmentHeight / 2
        segmentControl.realCornerRadius = cornerRadius
        segmentControl.layer.cornerRadius = cornerRadius
        segmentControl.backgroundColor = Colors.offWhite
    }
}

extension Stylesheet {
    static func applyOn(_ view: EventDetailHeaderView) {
        typealias context = Contexts.EventHeader
        
        let vTitle = view.titleLabel
        let vDate = view.dateLabel
        let vTime = view.timeLabel
        
        // Light
        vTitle.font = UIFont(font: Fonts.Regular, size: 20.calculateWidth())
        // Bold
        vDate.font = UIFont(font: Fonts.Regular, size: 16.calculateWidth())
        // Regular
        vTime.font = UIFont(font: Fonts.Regular, size: 16.calculateWidth())
        
        vTitle.textColor = context.TextColor
        vDate.textColor = context.TextColor
        vTime.textColor = context.TextColor
        
        view.backgroundColor = context.BackgroundColor
    }
}
