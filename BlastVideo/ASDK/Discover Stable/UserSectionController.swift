//
//  UserSectionController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/2/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
import UIKit
import AsyncDisplayKit
import IGListKit

class UserSectionController: ListSectionController, ASSectionController {
    
    func nodeForItem(at index: Int) -> ASCellNode {
        guard let user = object else { return ASCellNode() }
        
        return UsernameNode(user: user)
    }
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
    }
    
    var object: UserObject?
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        guard let user = object else { return {
            return ASCellNode()
            }
        }
        return {
            return UsernameNode(user: user)
        }
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? UserObject
    }
    
    override func didSelectItem(at index: Int) { }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return ASIGListSectionControllerMethods.sizeForItem(at: index)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
    }
}

