//
//  EmptyView.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 8/9/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    var titleLabel = UILabel()
    var imageView = UIImageView()
    
    init(superView: UIView, title: String) {
        let frame = superView.frame
        super.init(frame: frame);
        
        imageView.frame = CGRect(x: frame.minX, y: frame.minY + 50.calculateHeight(), width: frame.width, height: frame.height / 4)
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "JustKibblDog")
        self.addSubview(imageView)

        titleLabel.frame = CGRect(x: imageView.frame.minX, y: imageView.frame.maxY, width: frame.width, height: imageView.frame.height / 3)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 20.calculateWidth())
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
}
