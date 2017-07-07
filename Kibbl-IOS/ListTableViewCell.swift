//
//  ListTableViewCell.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/9/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable
import SnapKit
import SwifterSwift

class ListTableViewCell: UITableViewCell, Reusable {
    let containerView = UIView()
    let cellLabel = UILabel()
    let cellImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(cellLabel)
        
//        Stylesheet.applyOn(self)
        
        setupConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    func setupConstraints() {
        self.contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().priority(99)
            make.bottom.equalTo(containerView).offset(10).priority(100)
        }
        
        cellLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp.top).inset(10)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(5)
        }
        
//        containerView.snp.makeConstraints { (make) -> Void in
//            make.top.left.right.equalToSuperview()
//            make.bottom.equalTo(cellDetailLabel)
//        }
    }
    
//    func setupCell(_ item: ItemProperty) {
//        cellLabel.attributedText = item.key.underline
//    }
}

class CustomTableCell: UITableViewCell, Reusable {

}
