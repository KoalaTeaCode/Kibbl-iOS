//
//  EmbeddedCollectionViewTableViewCell.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/7/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable
import SnapKit
import SwifterSwift
import KoalaTeaFlowLayout

class EmbeddedCollectionViewTableViewCell: UITableViewCell, Reusable {
    var collectionView: UICollectionView!
    var data = ["Housetrained", "Neutered", "Vaccinations","Good with Kids","Good with Dogs","No Cats"]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        Stylesheet.applyOn(self)
        setupCollectionView()
        setupConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    func setupConstraints() {
        
    }
    
    //    func setupCell(_ item: ItemProperty) {
    //        cellLabel.attributedText = item.key.underline
    //        cellDetailLabel.text = item.value
    //    }
}

extension EmbeddedCollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setupCollectionView() {
        let layout = KoalaTeaFlowLayout(ratio: 1, topBottomMargin: 0, leftRightMargin: 10, cellsAcross: 3, cellSpacing: 10)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        collectionView.register(cellType: PetSkillsCollectionViewCell.self)
        
        self.contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().priority(99)
            make.bottom.equalTo(collectionView).priority(100)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as PetSkillsCollectionViewCell
        
        // Configure the cell
        let item = data[indexPath.row]
        cell.cellLabel.text = item
        //        cell.backgroundColor = .clear
        
        return cell
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if (self.superview != nil) {
            self.superview?.layoutIfNeeded()
        }

        let height = collectionView.contentSize.height + 20
        return CGSize(width: collectionView.contentSize.width, height: height)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize(width: 20, height: 20)
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return 0
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        return 10
    //    }
}
