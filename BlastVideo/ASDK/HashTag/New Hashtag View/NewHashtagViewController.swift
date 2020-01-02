//
//  NewHashtagCiewController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/17/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.


import Foundation
import AsyncDisplayKit
import IGListKit
import XLPagerTabStrip

class NewHashtagViewController: ASViewController<ASCollectionNode> {
    
    //static let shared = NewHashtagViewController()
    let navigation = NavigationBarNode()
    let collectionNode: ASCollectionNode!
    var refreshControl : UIRefreshControl?
    var layout: FeedLayout
    var hashtag: String?
    
    var pageTitle: String?
    
    var feedItems: [FeedItem] = [FeedItem]()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 1)
    }()
    
    init(hashtag: String) {
        self.hashtag = hashtag
        layout = FeedLayout()
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        super.init(node: self.collectionNode)
        self.adapter.setASDKCollectionNode(self.collectionNode)
        self.adapter.dataSource = self
        self.collectionNode.alwaysBounceVertical = true
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        self.collectionNode.view.addSubview(refreshControl!)
        
    }
    
    @objc func refreshContent(){
        HashtagData.shared.feedItems.removeAll()
        //fetchDetailInfo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        //fetchDetailInfo()
    }
    
//    private func fetchDetailInfo() {
//        HashtagData.shared.fetchPosts(hashtag: self.hashtag!) { (feedItems) in
//            self.feedItems = feedItems
//            self.updateUI()
//        }
//    }
    
    private func updateUI() {
        adapter.performUpdates(animated: true, completion: nil)
        refreshControl?.endRefreshing()
    }

    
    
}

extension NewHashtagViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return adapter.sizeForItem(at: indexPath)
    }
    
}

extension NewHashtagViewController: ListAdapterDataSource {
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is FeedItem:
            let feedController = FeedSectionController()
            feedController.delegate = self
            feedController.pushViewDelegate = self
            feedController.pushUserDelegate = self
            return feedController
        default:
            return ListSectionController()
        }
        
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        //return posts as [ListDiffable]
        let items: [ListDiffable] = feedItems
        return items
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }
}

extension NewHashtagViewController: DiscoverDataDelegate {
    func pushData(feedItems: [FeedItem]) {
        self.feedItems = feedItems
        adapter.performUpdates(animated: false, completion: nil)
    }
}
extension NewHashtagViewController: PushViewControllerDelegate {
    func pushViewController(post: Post, user: UserObject) {
        let detailViewController = ASDetailViewController(post: post, user: user)
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
//TODO: Add code to set up header and two view controllers which contains users posts and favorites
//Set up layout based on if the user has posts, favorites
//Update model to reflect if user has posts/favorites - check this then make network call
extension NewHashtagViewController: PushUsernameDelegate {
    func pushUser(user: UserObject) {
        let vc = PushProfileViewController()
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewHashtagViewController {
    
    func setupNavBar() {
        let navLabel = UILabel()
        let font = UIFont.init(name: "Modulus-Bold", size: 24.0)
        let navTitle = NSMutableAttributedString(string: "#"+hashtag!, attributes:[
            NSAttributedString.Key.font: font!,
            NSAttributedString.Key.foregroundColor: UIColor.black])
        
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
    }
    
    @objc func pushSearch(){

    }
    
}

extension NewHashtagViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Tab 1)")
    }
}
