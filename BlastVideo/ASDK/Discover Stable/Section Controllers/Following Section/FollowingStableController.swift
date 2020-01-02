//
//  FollowingStableController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 12/5/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import SJSegmentedScrollView
import XLPagerTabStrip
import IGListKit
import DeepDiff

class FollowingStableController: ASViewController<ASCollectionNode> {
    
    let layout = UICollectionViewFlowLayout()
    var feedItems: [FeedItem] = [FeedItem]()
    let data = FollowingData.shared
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
        Api.Feed.observeFeedCount { (count) in
            print(count)
            if count > 7 {
                self.fetchPosts(limit: 8)
            } else {
                self.fetchPosts(limit: UInt(bitPattern: count))
            }
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshContent), name: Notification.Name("refreshDiscover"), object: nil)
    }
    
    @objc func refreshContent(){
        data.feedItems.removeAll()
        Api.Feed.observeFeedCount { (count) in
            print(count)
            if count > 7 {
                self.fetchPosts(limit: 8)
            } else {
                self.fetchPosts(limit: UInt(bitPattern: count))
            }
            
        }
    }
    
    func fetchPosts(limit: UInt){
        
        if let id = currentUserGlobal.id {
            data.fetchPosts(with: id, limit: limit) { (feedItems) in
                if feedItems.count == 0 {
                    let label = UILabel()
                    label.textAlignment = .center
                    label.translatesAutoresizingMaskIntoConstraints = false
                    //label.frame = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 120, height: 45)
                    label.frame = .zero
                    label.attributedText = NSAttributedString(string: "You aren't following anyone", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
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
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endRefreshDiscover"), object: nil)
                        
                    }))
                    
                }
            }
        } else {
            let label = ASTextNode()
            label.view.translatesAutoresizingMaskIntoConstraints = false
            //label.frame = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 120, height: 45)
            label.frame = .zero
            label.attributedText = NSAttributedString(string: "You aren't Signed In", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
            self.node.addSubnode(label)
            NSLayoutConstraint.activate([
                label.view.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
                label.view.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: -100),
                label.view.heightAnchor.constraint(equalToConstant: 45),
                label.view.widthAnchor.constraint(equalToConstant: 120)
            ])
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension FollowingStableController: PushViewControllerDelegate {
    func pushViewController(post: Post, user: UserObject) {
        let detailViewController = ASDetailViewController(post: post, user: user)
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
//TODO: Add code to set up header and two view controllers which contains users posts and favorites
//Set up layout based on if the user has posts, favorites
//Update model to reflect if user has posts/favorites - check this then make network call
extension FollowingStableController: PushUsernameDelegate {
    func pushUser(user: UserObject) {
        let vc = PushProfileViewController()
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FollowingStableController {
    
    func setupNavBar() {
        let backBarButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc func pushSearch(){

    }
    
}

// MARK: ASTableDataSource / ASTableDelegate

extension FollowingStableController: ASCollectionDataSource, ASCollectionDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 140.0, right: 10.0)
    }
    
    func collectionView(_ collectionNode: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }

    func collectionView(_ collectionView: ASCollectionView, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let feedItem = feedItems[indexPath.row]
        let cell = DiscoverCellNode(post: feedItem.post, user: feedItem.user)
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
        if !data.isLoadingPost && !data.firstFetch && data.newItems > 7 {
            isLoading = true
            data.fetchMorePosts{ (feedItems) in
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

extension FollowingStableController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Discover)")
    }
}


