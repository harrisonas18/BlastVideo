//
//  FeedLayout.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/6/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit

class FeedLayout: UICollectionViewFlowLayout {
    
    // MARK: - Variables
    let itemHeight: CGFloat = 330
    let numberOfColumns: CGFloat = 1.0
    let screen = UIScreen.main.bounds
    var width: CGFloat = 0.0
    var collectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    // MARK: - Object life cycle
    
    override init() {
        super.init()
        self.setupLayout()
        width = screen.width
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupLayout()
    }
    
    // MARK: - Layout
    private func setupLayout() {
        self.minimumInteritemSpacing = 10.0
        self.minimumLineSpacing = 15.0
        self.scrollDirection = .vertical
        self.sectionInset = collectionInsets
    }
    
    func itemWidth() -> CGFloat {
        let insets = collectionInsets.left + collectionInsets.right
        let itemSpacing = minimumInteritemSpacing
        let width = self.width - (insets + itemSpacing)
        let itemWidth = width / numberOfColumns
        return itemWidth
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width: itemWidth(), height: itemHeight)
        }
        get {
            return CGSize(width: itemWidth(), height: itemHeight)
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return self.collectionView!.contentOffset
    }
    
}
