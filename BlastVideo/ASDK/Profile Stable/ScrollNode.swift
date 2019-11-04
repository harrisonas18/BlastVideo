//
//  ScrollNode.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/14/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class ScrollNode: ASScrollNode {
    
    var collectionNode: ASCollectionNode
    
    let header: ASDisplayNode = {
        let node = ASDisplayNode()
        node.style.preferredSize = CGSize(width: UIScreen.screenWidth(), height: 220.0)
        node.borderColor = UIColor.blue.cgColor
        node.borderWidth = 2.0
        return node
    }()
    
    override init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.screenWidth(), height: UIScreen.screenHeight())
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        collectionNode.style.preferredSize = CGSize(width: UIScreen.screenWidth(), height: UIScreen.screenHeight())
        super.init()
        self.backgroundColor = .white
        collectionNode.delegate = self
        collectionNode.dataSource = self
        collectionNode.view.isPagingEnabled = true
        collectionNode.borderColor = UIColor.green.cgColor
        collectionNode.borderWidth = 2.0
        automaticallyManagesSubnodes = true
        automaticallyManagesContentSize = true
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let stack = ASStackLayoutSpec.vertical()
        stack.alignItems = .center
        stack.justifyContent = .start
        stack.spacing = 10.0
        stack.children = [collectionNode]
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: stack)
        
    }
    
}

extension ScrollNode: UICollectionViewDelegateFlowLayout {
    
//    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
//        return ASSizeRange(min: CGSize(width: UIScreen.screenWidth(), height: UIScreen.screenHeight()*2), max: CGSize(width: UIScreen.screenWidth(), height: UIScreen.screenHeight()*2))
//    }
    
}

extension ScrollNode: ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let node = TestCollection()
        node.borderColor = UIColor.black.cgColor
        node.borderWidth = 2.0
        return node
    }
    
}

extension ScrollNode: ASCollectionDataSource {
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}
