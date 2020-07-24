//
//  PushProfileFavs.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 12/8/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
import Foundation
import AsyncDisplayKit
import XLPagerTabStrip
import DeepDiff

class PushProfileFavs: ASViewController<ASCollectionNode> {
    
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
        Api.Favorites.observeFavsCount(id: user?.id ?? "") { (count) in
            print(count)
            if count > 7 {
                self.fetchPosts(limit: 8)
            } else {
                self.fetchPosts(limit: UInt(bitPattern: count))
            }
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshContent), name: Notification.Name("refreshProfile"), object: nil)
    }
    
    @objc func refreshContent(){
        NewProfileData.shared.favFeedItems.removeAll()
        Api.Favorites.observeFavsCount(id: user?.id ?? "") { (count) in
            print(count)
            if count > 7 {
                self.fetchPosts(limit: 8)
            } else {
                self.fetchPosts(limit: UInt(bitPattern: count))
            }
            
        }
        
    }
    
    func fetchPosts(limit: UInt){
        data.fetchUserFavs(user: currentUserGlobal, limit: limit) { (feedItems) in
            if feedItems.count == 0 {
                let label = ASTextNode()
                label.view.translatesAutoresizingMaskIntoConstraints = false
                //label.frame = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 120, height: 45)
                label.frame = .zero
                label.attributedText = NSAttributedString(string: "Ah Bummer no favorites", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
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
extension PushProfileFavs: UICollectionViewDelegateFlowLayout {
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let insets = layout.collectionInsets.right + layout.collectionInsets.left
        let itemSpacing = layout.minimumInteritemSpacing
        let width = layout.width - (insets + itemSpacing)
        let itemWidth = width / layout.numberOfColumns
        return ASSizeRangeMake(CGSize(width: itemWidth, height: 100), CGSize(width: itemWidth, height: 450))
    }
}

extension PushProfileFavs: PushUsernameDelegate {
    
    func pushUser(user: UserObject) {
        
    }
    
}

// MARK: ASTableDataSource / ASTableDelegate

extension PushProfileFavs: ASCollectionDataSource, ASCollectionDelegate {
    
    
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
    
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        if isLoading {
            return false
        }
        return true
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        if !NewProfileData.shared.isLoadingPost && !NewProfileData.shared.firstFetchFavs && NewProfileData.shared.newItems > 7 {
            isLoading = true
            NewProfileData.shared.fetchMoreUserFavs(user: currentUserGlobal) { (feedItems) in
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

extension PushProfileFavs: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Tab 2")
    }
}
