//
//  ShelterDetailHeaderView.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/25/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit

class ShelterDetailHeaderView: UIView {
    
    let kibbleImageView = UIImageView()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.performLayout()
//        Stylesheet.applyOn(self)
        
        self.backgroundColor = Stylesheet.Colors.light2
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
    
    func performLayout() {
        self.addSubview(kibbleImageView)
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints{ (make) in
            make.edges.equalToSuperview()
        }
        
        kibbleImageView.snp.makeConstraints{ (make) in
            make.height.equalToSuperview().dividedBy(2)
            make.width.equalToSuperview().dividedBy(2)
            make.center.equalToSuperview()
        }
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        kibbleImageView.image = #imageLiteral(resourceName: "JustKibblDog")
        kibbleImageView.contentMode = .scaleAspectFit
    }
    
    func setupHeader(shelter: ShelterModel) {
        guard let imageURL = shelter.imageURL1 else { return }
        
        if let url = URL(string: imageURL) {
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: url)
        }
    }
}
