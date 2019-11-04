//
//  ProfileFavoritesVC.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/20/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import XLPagerTabStrip

class ProfileFavoritesVC: ASViewController<ASCollectionNode> {
    
    let layout = ProfilePostsLayout()
    var feedItems: [FeedItem] = [FeedItem]()
    let data = NewProfileData.shared
    
    var pageTitle: String?
    
    private var collectionNode: ASCollectionNode {
        return node
    }
    
    init() {
        super.init(node: ASCollectionNode(collectionViewLayout: layout))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionNode.delegate = self
        collectionNode.dataSource = self
        data.fetchUserFavs(userID: currentUserGlobal){ (feedItems) in
            self.feedItems = feedItems
            let indexRange = (self.feedItems.count - feedItems.count..<self.feedItems.count)
            let indexPaths = indexRange.map { IndexPath(row: $0, section: 0) }
            DispatchQueue.main.async {
                self.collectionNode.insertItems(at: indexPaths)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
extension ProfileFavoritesVC: UICollectionViewDelegateFlowLayout {
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let insets = layout.collectionInsets.right + layout.collectionInsets.left
        let itemSpacing = layout.minimumInteritemSpacing
        let width = layout.width - (insets + itemSpacing)
        let itemWidth = width / layout.numberOfColumns
        return ASSizeRangeMake(CGSize(width: itemWidth, height: 100), CGSize(width: itemWidth, height: 450))
    }
}

extension ProfileFavoritesVC: PushUsernameDelegate {
    
    func pushUser(user: UserObject) {
        
    }
    
}

// MARK: ASTableDataSource / ASTableDelegate

extension ProfileFavoritesVC: ASCollectionDataSource, ASCollectionDelegate {
    
    
    func collectionView(_ collectionNode: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func collectionView(_ collectionView: ASCollectionView, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let feedItem = feedItems[indexPath.row]
        let cell = CollectionPostCellNode(post: feedItem.post, user: feedItem.user)
        //cell.contentNode.delegate = self
        return cell
    }
    
    func collectionView(_ collectionNode: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedItem = feedItems[indexPath.row]
        let detailViewController = ASDetailViewController(post: feedItem.post, user: feedItem.user)
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ProfileFavoritesVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Tab 2")
    }
}
