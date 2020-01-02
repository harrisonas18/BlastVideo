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
import IGListKit
import DeepDiff

class ProfilePostsVC: ASViewController<ASCollectionNode> {
    
    let layout = ProfilePostsLayout()
    var feedItems: [FeedItem] = [FeedItem]()
    let data = NewProfileData.shared
    var newPosts = 0
    var isLoading = false
    var count = 0
    
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
        Api.MyPosts.observeMyPostsCount(id: currentUserGlobal.id ?? "") { (count) in
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
    
    @objc func refreshContent(){
        NewProfileData.shared.feedItems.removeAll()
        Api.MyPosts.observeMyPostsCount(id: currentUserGlobal.id ?? "") { (count) in
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
        data.fetchUserPosts(user: currentUserGlobal, limit: limit) { (feedItems) in
            print("Feed items count profile ",feedItems.count)
            if feedItems.count == 0 {
                let label = UILabel()
                label.textAlignment = .center
                label.translatesAutoresizingMaskIntoConstraints = false
                //label.frame = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 120, height: 45)
                label.frame = .zero
                label.attributedText = NSAttributedString(string: "You don't have any Posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
                self.node.view.addSubview(label)
                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                    label.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: -100),
                    label.heightAnchor.constraint(equalToConstant: 45),
                    label.widthAnchor.constraint(equalToConstant: UIScreen.screenWidth())
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
        if !NewProfileData.shared.isLoadingPost && !NewProfileData.shared.firstFetchPosts && NewProfileData.shared.newItems > 7 {
            isLoading = true
            NewProfileData.shared.fetchMoreUserPosts(user: currentUserGlobal) { (feedItems) in
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
extension ProfilePostsVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Tab 3)")
    }
}
