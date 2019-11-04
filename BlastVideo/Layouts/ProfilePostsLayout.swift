//
//  DiscoverCollectionLayout.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 4/15/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import AsyncDisplayKit


class ProfilePostsLayout: UICollectionViewFlowLayout {
    
    // MARK: - Variables
    let itemHeight: CGFloat = 300
    let numberOfColumns: CGFloat = 2.0
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
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attrs = super.layoutAttributesForElements(in: rect) {
            var baseline: CGFloat = -2
            var sameLineElements = [UICollectionViewLayoutAttributes]()
            for element in attrs {
                if element.representedElementCategory == .cell {
                    let frame = element.frame
                    let centerY = frame.midY
                    if abs(centerY - baseline) > 1 {
                        baseline = centerY
                        alignToTopForSameLineElements(sameLineElements: sameLineElements)
                        sameLineElements.removeAll()
                    }
                    sameLineElements.append(element)
                }
            }
            alignToTopForSameLineElements(sameLineElements: sameLineElements) // align one more time for the last line
            return attrs
        }
        return nil
    }
    
    private func alignToTopForSameLineElements(sameLineElements: [UICollectionViewLayoutAttributes]) {
        if sameLineElements.count <= 1 { return }
        let sorted = sameLineElements.sorted { (obj1: UICollectionViewLayoutAttributes, obj2: UICollectionViewLayoutAttributes) -> Bool in
            let height1 = obj1.frame.size.height
            let height2 = obj2.frame.size.height
            let delta = height1 - height2
            return delta <= 0
        }
        if let tallest = sorted.last {
            for obj in sameLineElements {
                obj.frame = obj.frame.offsetBy(dx: 0, dy: obj.frame.origin.y - tallest.frame.origin.y  )
            }
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return self.collectionView!.contentOffset
    }
    
}
