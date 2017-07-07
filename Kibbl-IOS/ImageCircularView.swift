//
//  ImageCircularView.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/26/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SnapKit
import FittableFontLabel

class ImageCircularView: UIView {

    var contentView = UIView()
    var imageView = UIImageView()
    var kibblLogoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.performLayout()
//        Stylesheet.applyOn(self)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
    
    override func layoutSubviews() {
        let cornerRadius = imageView.frame.size.height / 2
        
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
    }
    
    func performLayout() {
        self.addSubview(contentView)
        self.contentView.addSubview(imageView)
        self.imageView.addSubview(kibblLogoImageView)
        
        contentView.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview().inset(17)
            make.bottom.equalToSuperview().inset(17)
        }
        
        imageView.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview()
            make.width.equalTo(contentView.snp.height)
            make.center.equalToSuperview()
        }
        
        kibblLogoImageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview().inset(8)
        }
        
        self.kibblLogoImageView.image = #imageLiteral(resourceName: "JustKibblDog")
        self.kibblLogoImageView.contentMode = .scaleAspectFit
        self.imageView.backgroundColor = Stylesheet.Colors.base
    }
    
    func setImage(imageURL: String?) {
        guard let url = imageURL else {
            self.imageView.image = UIImage()
            
            self.kibblLogoImageView.image = #imageLiteral(resourceName: "JustKibblDog")
            self.imageView.backgroundColor = Stylesheet.Colors.base
            return
        }
        if let imageURL = URL(string: url) {
            self.kibblLogoImageView.image = UIImage()
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: imageURL)
            self.imageView.contentMode = .scaleAspectFill
            self.imageView.backgroundColor = .clear
        }
    }
}
