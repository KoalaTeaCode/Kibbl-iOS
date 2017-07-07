//
//  CircularTitleview.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 4/27/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SnapKit
import FittableFontLabel

class CircularTitleView: UIView {
    
    let titleLabel = LabelWithAdaptiveTextHeight()
    var contentView = UIView()
    var labelView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.performLayout()
        Stylesheet.applyOn(self)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
    
    override func layoutSubviews() {
        let cornerRadius = labelView.frame.size.height / 2
        
        labelView.layer.cornerRadius = cornerRadius
        labelView.clipsToBounds = true
    }
    
    func performLayout() {
        self.addSubview(contentView)
        self.contentView.addSubview(labelView)
        self.labelView.addSubview(titleLabel)
        
        titleLabel.text = "28" + "\n" + "MAR"
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.25
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.baselineAdjustment = .alignCenters
        
        contentView.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview().inset(17)
            make.bottom.equalToSuperview().inset(17)
        }
        
        labelView.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview()
            make.width.equalTo(contentView.snp.height)
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func setTitleText(text: String?) {
        titleLabel.text = text
    }
}
