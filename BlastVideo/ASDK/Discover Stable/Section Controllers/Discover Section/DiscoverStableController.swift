//
//  DiscoverV2.swift
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

protocol PushDiscoverDataDelegate {
    func pushUser(user: UserObject)
    func pushHashtag(hashtag: String)
}

class DiscoverStableController: ASViewController<ASCollectionNode> {
    
    let layout = UICollectionViewFlowLayout()
    var feedItems: [FeedItem] = [FeedItem]()
    let data = DiscoverData.shared
    var newPosts = 0
    var isLoading = false
    var count = 0
    var dataDelegate: PushDiscoverDataDelegate?
    
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
        //collectionNode.view.isPagingEnabled = true
        collectionNode.allowsSelection = false
        //collectionNode.leadingScreensForBatching = 1.0
        Api.Post.observePostCount { (count) in
            print("Post Count Discover: ", count)
            if count > 7 {
                self.fetchPosts(limit: 8)
            } else {
                self.fetchPosts(limit: UInt(bitPattern: count))
            }
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshContent), name: Notification.Name("refreshDiscover"), object: nil)
    }
    
    @objc func refreshContent(){
        DiscoverData.shared.feedItems.removeAll()
        Api.Post.observePostCount { (count) in
            if count > 7 {
                self.fetchPosts(limit: 8)
            } else {
                self.fetchPosts(limit: UInt(bitPattern: count))
            }
            
        }
    }
    
    func fetchPosts(limit: UInt){
        self.isLoading = true
        data.fetchPosts(limit: limit) { (feedItems) in
            print("results in")
            self.isLoading = false
            if feedItems.count == 0 {
                let label = UILabel()
                label.textAlignment = .center
                label.translatesAutoresizingMaskIntoConstraints = false
                //label.frame = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 120, height: 45)
                label.frame = .zero
                label.attributedText = NSAttributedString(string: "No Posts to show", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension DiscoverStableController: PushViewControllerDelegate {
    func pushViewController(post: Post, user: UserObject) {
        let detailViewController = ASDetailViewController(post: post, user: user)
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
//TODO: Add code to set up header and two view controllers which contains users posts and favorites
//Set up layout based on if the user has posts, favorites
//Update model to reflect if user has posts/favorites - check this then make network call
extension DiscoverStableController: PushUsernameDelegate {
    func pushUser(user: UserObject) {
        //Add delegate that feeds data to parent = DiscoverPageController
        //Forward user to DiscoverPageController and Push user profile from there
        //dataDelegate?.pushUser(user: user)
        let vc = PushProfileViewController()
        //vc.hidesBottomBarWhenPushed = true
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DiscoverStableController {
    
    func setupNavBar() {
        let backBarButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc func pushSearch(){

    }
    
}
// MARK: ASTableDataSource / ASTableDelegate

extension DiscoverStableController: ASCollectionDataSource, ASCollectionDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 140.0, right: 0)
    }
    
    func collectionView(_ collectionNode: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }

    func collectionView(_ collectionView: ASCollectionView, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let feedItem = feedItems[indexPath.row]
        let cell = DiscoverFullCell(post: feedItem.post, user: feedItem.user)
        cell.contentNode.delegate = self
        return cell
    }
    
    func collectionView(_ collectionNode: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedItem = feedItems[indexPath.row]
        let vc = ASDetailViewController(post: feedItem.post, user: feedItem.user)
        vc.hidesBottomBarWhenPushed = true
        vc.pushUserDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        if isLoading {
            return false
        }
        return true
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        if !DiscoverData.shared.isLoadingPost && !DiscoverData.shared.firstFetch && DiscoverData.shared.newItems > 7 {
            isLoading = true
            print("Fetching more")
            DiscoverData.shared.fetchMorePosts{ (feedItems) in
                print("New Feed Items Count: ", feedItems.count)
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

extension DiscoverStableController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Discover)")
    }
}


