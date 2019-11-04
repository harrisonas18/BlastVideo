//
//  TestCollection.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/13/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class TestCollection: ASCellNode {
    
    var collection: ASCollectionNode
    var nums = ["Test1","Test2","Test3","Test4","Test5","Test6" ]
    
    
    override init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.screenWidth(), height: UIScreen.screenHeight() / 6)
        self.collection = ASCollectionNode(collectionViewLayout: layout)
        super.init()
        collection.style.preferredSize = CGSize(width: UIScreen.screenWidth(), height: UIScreen.screenHeight())
        collection.delegate = self
        collection.dataSource = self
        automaticallyManagesSubnodes = true
        collection.view.isScrollEnabled = false
        collection.alwaysBounceVertical = false
        collection.view.contentOffset = CGPoint(x: 0, y: 128.0)
        
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: collection)
    }
}

extension TestCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.screenWidth(), height: 100)
    }
}

extension TestCollection: ASCollectionDelegate {
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let num = nums[indexPath.row]
        let node = TextCellNode(text: num)
        return node
    }
    
}

extension TestCollection: ASCollectionDataSource {
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return nums.count
    }
}

class TextCellNode: ASCellNode {
    
    let textNode = ASTextNode()
    let text: String
    
    init(text: String) {
        self.text = text
        super.init()
        self.textNode.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .light)])
        self.borderColor = UIColor.red.cgColor
        self.borderWidth = 1.0
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        self.textNode.attributedText = NSAttributedString(string: self.text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .light)])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: textNode)
    }
}


