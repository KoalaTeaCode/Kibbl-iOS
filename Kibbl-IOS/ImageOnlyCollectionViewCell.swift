//
//  ImageOnlyCollectionViewCell.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/25/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable

class ImageOnlyCollectionViewCell: UICollectionViewCell, Reusable {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    func setupConstraints() {
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        
        imageView.contentMode = .scaleAspectFit
        self.backgroundColor = .white
    }
}
