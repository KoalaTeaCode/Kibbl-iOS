//
//  PetDetailHeaderView.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/25/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Reusable

class PetDetailHeaderView: UIView {
    
    let kibbleImageView = UIImageView()
    let imageView = UIImageView()
    
    // Collection View Properties
    var pet: PetModel!
    var data = [String]()
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var pageControl = UIPageControl()
    
    var thisWidth: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    convenience init(frame: CGRect, pet: PetModel) {
        self.init(frame: frame);
        
        self.pet = pet
        self.performLayout()
//        Stylesheet.applyOn(self)
        
        self.backgroundColor = Stylesheet.Colors.light2
        collectionView.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
    
    func performLayout() {
        self.addSubview(kibbleImageView)
        
        kibbleImageView.snp.makeConstraints{ (make) in
            make.height.equalToSuperview().dividedBy(2)
            make.width.equalToSuperview().dividedBy(2)
            make.center.equalToSuperview()
        }
 
        kibbleImageView.image = #imageLiteral(resourceName: "JustKibblDog")
        kibbleImageView.contentMode = .scaleAspectFit
        
        setupCollectionView()
    }
}

extension PetDetailHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        data = pet.getImageURLS()
        
        self.addSubview(collectionView)
        self.addSubview(pageControl)
        
        collectionView.snp.makeConstraints{ (make) in
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        thisWidth = CGFloat(self.frame.width)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(cellType: ImageOnlyCollectionViewCell.self)
        
        pageControl.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        pageControl.numberOfPages = data.count
        pageControl.hidesForSinglePage = true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as ImageOnlyCollectionViewCell
        
        
        let imageURL = data[indexPath.section]
        if let url = URL(string: imageURL) {
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: url)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        thisWidth = CGFloat(self.frame.width)
        return CGSize(width: thisWidth, height: self.frame.height)
    }
}
