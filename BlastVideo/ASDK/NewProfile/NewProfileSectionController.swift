//
//  NewProfileSectionController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/11/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
import UIKit
import AsyncDisplayKit
import IGListKit

protocol PushDataDelegate: class {
    func pushData(feedItems: [FeedItem])
}

class NewProfileSectionController: ListSectionController, ASSectionController {
    
    weak var delegate: PushDataDelegate?
    var pushViewDelegate: PushViewControllerDelegate?
    var pushUserDelegate: PushUsernameDelegate?
    var isLoading: Bool
    
    func nodeForItem(at index: Int) -> ASCellNode {
        guard let feedItem = object else { return ASCellNode() }
        
        let node = ASCellNode()
        return node
    }
    
    override init() {
        self.isLoading = false
        super.init()
        self.inset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
    }
    
    var object: FeedItem?
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        guard let feedItem = object else { return {
            return ASCellNode()
            }
        }
        return {
            let node = CollectionPostCellNode(post: feedItem.post, user: feedItem.user)
            return node
        }
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? FeedItem
    }
    
    override func didSelectItem(at index: Int) {
        guard let feedItem = object else { return }
        pushViewDelegate?.pushViewController(post: feedItem.post, user: feedItem.user)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return ASIGListSectionControllerMethods.sizeForItem(at: index)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
    }
    
}

extension NewProfileSectionController {
    
    func shouldBatchFetch() -> Bool {
        if isLoading {
            return false
        }
        return true
    }
    
    func beginBatchFetch(with context: ASBatchContext) {
        
        if !NewProfileData.shared.isLoadingPost && !NewProfileData.shared.firstFetchPosts {
            isLoading = true
            NewProfileData.shared.fetchMoreUserPosts { (feedItems) in
                DispatchQueue.main.async {
                    self.delegate?.pushData(feedItems: feedItems)
                }
                self.isLoading = false
                context.completeBatchFetching(true)
            }
        } else {
            context.completeBatchFetching(true)
        }
        
    }
    
}

extension NewProfileSectionController: PushUsernameDelegate {
    func pushUser(user: UserObject) {
        pushUserDelegate?.pushUser(user: user)
    }
}
