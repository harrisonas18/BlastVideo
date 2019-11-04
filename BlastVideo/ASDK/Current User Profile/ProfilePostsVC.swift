//
//  ProfilePostsVC.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/20/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import SJSegmentedScrollView
import XLPagerTabStrip

class ProfilePostsVC: ASViewController<ASCollectionNode> {
    
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
        layout.collectionInsets.bottom = 60.0
        collectionNode.delegate = self
        collectionNode.dataSource = self
        data.fetchUserPosts(user: currentUserGlobal) { (feedItems) in
            if feedItems.count == 0 {
                let label = ASTextNode()
                label.frame = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 120, height: 45)
                label.attributedText = NSAttributedString(string: "You don't have any Posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
                self.node.addSubnode(label)
            }
            self.feedItems = feedItems
            let indexRange = (feedItems.count - feedItems.count..<feedItems.count)
            let indexPaths = indexRange.map { IndexPath(row: $0, section: 0) }
            DispatchQueue.main.async {
                self.collectionNode.insertItems(at: indexPaths)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProfilePost"), object: nil)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension ProfilePostsVC: PushUsernameDelegate {
    
    func pushUser(user: UserObject) {
        
    }
    
}

extension ProfilePostsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let insets = layout.collectionInsets.right + layout.collectionInsets.left
        let itemSpacing = layout.minimumInteritemSpacing
        let width = layout.width - (insets + itemSpacing)
        let itemWidth = width / layout.numberOfColumns
        return ASSizeRangeMake(CGSize(width: itemWidth, height: 100), CGSize(width: itemWidth, height: 450))
    }
    
}

// MARK: ASTableDataSource / ASTableDelegate

extension ProfilePostsVC: ASCollectionDataSource, ASCollectionDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 140.0, right: 10.0)
    }
    
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
extension ProfilePostsVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Tab 3)")
    }
}
