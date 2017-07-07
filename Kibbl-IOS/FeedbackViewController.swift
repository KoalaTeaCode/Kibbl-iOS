//
//  FeedbackViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 6/21/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SnapKit

class FeedbackViewController: UIViewController {
    
    var logoImageview = UIImageView()
    var descriptionLabel = UILabel()
    var urlLabel = UnderlinedLabel()
    var urlButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.performLayout()
        
        self.view.backgroundColor = Stylesheet.Colors.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performLayout() {
        self.view.addSubview(logoImageview)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(urlLabel)
        self.view.addSubview(urlButton)
        
        logoImageview.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(25)
            make.centerX.equalToSuperview()
            make.height.equalTo(Helpers.calculateHeight(forHeight: 250))
            make.width.equalTo(Helpers.calculateWidth(forWidth: 250))
        }
        
        logoImageview.image = #imageLiteral(resourceName: "KibbleWithText")
        logoImageview.contentMode = .scaleAspectFit
        
        descriptionLabel.text = "Have feedback for us?" + "\n" + "We love to hear!" + "\n" + "Just contact us at:"
        descriptionLabel.font = UIFont.systemFont(ofSize: 26)
        descriptionLabel.adjustsFontSizeToFitWidth = false
        descriptionLabel.minimumScaleFactor = 0.25
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.baselineAdjustment = .alignCenters
        descriptionLabel.textColor = Stylesheet.Colors.blackText
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageview.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }

        urlLabel.text = "admin@kibbl.io"
        urlLabel.font = UIFont.systemFont(ofSize: 30)
        urlLabel.adjustsFontSizeToFitWidth = false
        urlLabel.minimumScaleFactor = 0.25
        urlLabel.numberOfLines = 1
        urlLabel.lineBreakMode = .byTruncatingTail
        urlLabel.textAlignment = .center
        urlLabel.baselineAdjustment = .alignCenters
        urlLabel.textColor = Stylesheet.Colors.base
        
        urlLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        urlButton.addTarget(self, action: #selector(self.urlLabelTapped), for: .touchUpInside)
        
        urlButton.snp.makeConstraints { (make) in
            make.center.equalTo(urlLabel.snp.center)
            make.height.equalTo(urlLabel.snp.height)
            make.width.equalTo(urlLabel.snp.width)
        }
    }
    
    func urlLabelTapped() {
        let email = "admin@kibbl.io"
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
