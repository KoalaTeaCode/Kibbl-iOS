//
//  PushNotificationCollectionViewReusableView.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 6/15/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SnapKit
import Reusable
import FirebaseMessaging

class PushNotificationCollectionViewReusableView: UICollectionReusableView, Reusable {
    
    var fromViewController: UIViewController!
    
    var titleLabel = UILabel()
    var pushNotifSwitch = UISwitch()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.performLayout()
//        Stylesheet.applyOn(self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    func performLayout() {
        self.addSubview(titleLabel)
        self.addSubview(pushNotifSwitch)

        titleLabel.snp.makeConstraints{ (make) in
            make.left.equalToSuperview().inset(15)
            make.width.equalToSuperview().dividedBy(1.75)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.minimumScaleFactor = 0.25
        titleLabel.numberOfLines = 1
        titleLabel.textColor = UIColor(hex: 0xB7B4B1)
        titleLabel.text = "Enable Push Notifications"
        
        pushNotifSwitch.snp.makeConstraints{ (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
        }
        pushNotifSwitch.addTarget(self, action: #selector(self.switchValueDidChange(_:)), for: .valueChanged);
        
        guard let user = User.getActiveUser() else { return }
        pushNotifSwitch.isOn = user.pushNotificationsSetting
    }
    
    func switchValueDidChange(_ sender: UISwitch!)
    {
        guard let user = User.getActiveUser() else { return }
        if (sender.isOn == true){
            // Change notifs to on
            API.sharedInstance.setPushNotifications(to: true, deviceToken: Messaging.messaging().fcmToken!)
        }
        else{
            // Change notifs to off
            API.sharedInstance.setPushNotifications(to: false, deviceToken: Messaging.messaging().fcmToken!)
        }
    }
}
