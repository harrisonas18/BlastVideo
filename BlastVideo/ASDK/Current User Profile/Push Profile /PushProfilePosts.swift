//
//  PushProfilePosts.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 12/8/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import SJSegmentedScrollView
import XLPagerTabStrip
import IGListKit
import DeepDiff

class PushProfilePosts: ASViewController<ASCollectionNode> {
    
    let layout = ProfilePostsLayout()
    var feedItems: [FeedItem] = [FeedItem]()
    let data = PushProfileData.shared
    var newPosts = 0
    var isLoading = false
    var count = 0
    var user: UserObject?
    
    var pageTitle: String?
    
    private var collectionNode: ASCollectionNode {
        return node
    }
    
    init(user: UserObject) {
        self.user = user
        super.init(node: ASCollectionNode(collectionViewLayout: layout))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionNode.delegate = self
        collectionNode.dataSource = self
        Api.MyPosts.observeMyPostsCount(id: user?.id ?? "") { (count) in
            print("Profile posts count: ", count)
            if count > 7 {
                print("Profile fetch 8")
                self.fetchPosts(limit: 8)
            } else {
                print("Profile Fetching ", count)
                self.fetchPosts(limit: UInt(bitPattern: count))
            }
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshContent), name: Notification.Name("refreshProfile"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        data.clearData()
    }
    
    @objc func refreshContent(){
        data.feedItems.removeAll()
        Api.MyPosts.observeMyPostsCount(id: user?.id ?? "") { (count) in
            print("Profile Data: ",count)
            if count > 7 {
                print("Fetch 8 profile")
                self.fetchPosts(limit: 8)
            } else {
                print("Fetch ", count)
                self.fetchPosts(limit: UInt(bitPattern: count))
            }
        }
    }
    
    func fetchPosts(limit: UInt){
        data.fetchUserPosts(user: user ?? UserObject(), limit: limit) { (feedItems) in
            print("Feed items count profile ",feedItems.count)
            if feedItems.count == 0 {
                let label = ASTextNode()
                label.view.translatesAutoresizingMaskIntoConstraints = false
                //label.frame = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 120, height: 45)
                label.frame = .zero
                label.attributedText = NSAttributedString(string: "You don't have any Posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
                self.node.addSubnode(label)
                NSLayoutConstraint.activate([
                    label.view.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
                    label.view.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: -100),
                    label.view.heightAnchor.constraint(equalToConstant: 45),
                    label.view.widthAnchor.constraint(equalToConstant: 120)
                ])
            }
            
            DispatchQueue.main.async {
                let results = diff(old: self.feedItems, new: feedItems)
                self.collectionNode.view.reload(changes: results, updateData: ({
                    self.feedItems = feedItems
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endRefreshProfile"), object: nil)
                }))
                
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension PushProfilePosts: PushUsernameDelegate {
    
    func pushUser(user: UserObject) {
        
    }
    
}

extension PushProfilePosts: UICollectionViewDelegateFlowLayout {
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let insets = layout.collectionInsets.right + layout.collectionInsets.left
        let itemSpacing = layout.minimumInteritemSpacing
        let width = layout.width - (insets + itemSpacing)
        let itemWidth = width / layout.numberOfColumns
        return ASSizeRangeMake(CGSize(width: itemWidth, height: 100), CGSize(width: itemWidth, height: 450))
    }
    
}

// MARK: ASTableDataSource / ASTableDelegate

extension PushProfilePosts: ASCollectionDataSource, ASCollectionDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 140.0, right: 10.0)
    }
    
    func collectionView(_ collectionNode: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }

    func collectionView(_ collectionView: ASCollectionView, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let feedItem = feedItems[indexPath.row]
        let cell = CollectionPostCellNode(post: feedItem.post, user: feedItem.user)
        return cell
    }
    
    func collectionView(_ collectionNode: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedItem = feedItems[indexPath.row]
        let detailViewController = ASDetailViewController(post: feedItem.post, user: feedItem.user)
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        if isLoading {
            return false
        }
        return true
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        if !data.isLoadingPost && !data.firstFetchPosts && data.newItems > 7 {
            isLoading = true
            data.fetchMoreUserPosts(user: user ?? UserObject()) { (feedItems) in
                DispatchQueue.main.async {
                    let results = diff(old: self.feedItems, new: feedItems)
                    self.collectionNode.view.reload(changes: results, updateData: ({
                        self.feedItems = feedItems
                    }))
                    
                }
                self.isLoading = false
                context.completeBatchFetching(true)
            }
        } else {
            context.completeBatchFetching(true)
        }
    }
    
}
extension PushProfilePosts: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Tab 3)")
    }
}
