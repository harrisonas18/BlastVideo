//
//  DiscoverViewNodeController.swift
//
//
//


import UIKit
import AsyncDisplayKit
import GradientLoadingBar
import NotificationBannerSwift

class DiscoverViewNodeController: ASViewController<ASCollectionNode> {
  
    let layout = FeedLayout()
    var gradientBar : GradientLoadingBar?
    var refreshControl : UIRefreshControl?
    var firstFetch = true
    var posts: [Post] = []
    var users: [UserObject] = []
    var isLoadingPost = false
    var newItems = 0
    let notification = StatusBarNotificationBanner(title: "Success")
    
    private var collectionNode: ASCollectionNode {
            return node
    }

    init() {
        super.init(node: ASCollectionNode(collectionViewLayout: layout))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        collectionNode.delegate = self
        collectionNode.dataSource = self
        gradientBar = GradientLoadingBar(height: 5.0, isRelativeToSafeArea: true)
        gradientBar?.fadeIn()
        self.collectionNode.alwaysBounceVertical = true
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        self.collectionNode.view.addSubview(refreshControl!)
        
    }
    
    @objc func refreshContent(){
        refreshControl?.endRefreshing()
        clearPostData()
        self.isLoadingPost = false
        self.firstFetch = true
        self.collectionNode.reloadData()
    }
    
    func clearPostData(){
        posts.removeAll()
        users.removeAll()
    }
    
    
    func fetchNewBatchWithContext(_ context: ASBatchContext?) {
        if firstFetch {
            DispatchQueue.main.async {
                self.gradientBar?.fadeIn()
            }
            firstFetch = false
            self.isLoadingPost = true
            print("Recent post will call")
            Api.Post.getRecentPost(start: posts.first?.timestamp, limit: 8) { (results) in
                if results.count > 0 {
                    results.forEach({ (result) in
                        self.posts.append(result.0)
                        self.users.append(result.1)
                    })
                }
                self.newItems = results.count
                print("Results fetched: ", results.count)
                self.gradientBar?.fadeOut()
                self.addRowsIntoTableNode(newPhotoCount: results.count)
                context?.completeBatchFetching(true)
                self.isLoadingPost = false
            }
            
        } else {
            guard !isLoadingPost else {
                context?.completeBatchFetching(true)
                print("complete called")
                return
            }
            isLoadingPost = true
            
            guard let lastPostTimestamp = posts.last?.timestamp else {
                isLoadingPost = false
                print("timestamp called")
                return
            }
            print("Get old post called")
            Api.Post.getOldPost(start: lastPostTimestamp, limit: 8) { (results) in
                if results.count == 0 {
                    return
                }
                for result in results {
                    self.posts.append(result.0)
                    self.users.append(result.1)
                }
                self.newItems = results.count
                self.addRowsIntoTableNode(newPhotoCount: results.count)
                context?.completeBatchFetching(true)
                self.isLoadingPost = false
                
            }
        }
    }
    
    func addRowsIntoTableNode(newPhotoCount newPhotos: Int) {
        let indexRange = (posts.count - newPhotos..<posts.count)
        let indexPaths = indexRange.map { IndexPath(row: $0, section: 0) }
        DispatchQueue.main.async {
            self.collectionNode.insertItems(at: indexPaths)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

extension DiscoverViewNodeController: UICollectionViewDelegateFlowLayout {

    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let insets = layout.collectionInsets.right + layout.collectionInsets.left
        let itemSpacing = layout.minimumInteritemSpacing
        let width = layout.width - (insets + itemSpacing)
        let itemWidth = width / layout.numberOfColumns
        return ASSizeRangeMake(CGSize(width: itemWidth, height: 100), CGSize(width: itemWidth, height: 450))
    }
}

extension DiscoverViewNodeController: PushUsernameDelegate {
    
    func pushUser(user: UserObject) {
        
    }
    
}

// MARK: ASTableDataSource / ASTableDelegate

extension DiscoverViewNodeController: ASCollectionDataSource, ASCollectionDelegate {
    
    
    func collectionView(_ collectionNode: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: ASCollectionView, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        let cell = DiscoverCellNode(post: post, user: user)
        cell.contentNode.delegate = self
        return cell
    }
    
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        return true
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        print("Will begin batch fetch")
        fetchNewBatchWithContext(context)
    }
    
    func collectionView(_ collectionNode: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.item]
        let user = users[indexPath.item]
        let detailViewController = ASDetailViewController(post: post, user: user)
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension DiscoverViewNodeController {
    
    func setupNavBar() {
        let navLabel = UILabel()
        let font = UIFont.init(name: "Modulus", size: 24.0)
        let navTitle = NSMutableAttributedString(string: "LIVE", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: font!])
        let boldFont = UIFont.init(name: "Modulus-Bold", size: 24.0)
        navTitle.append(NSMutableAttributedString(string: "ME", attributes:[
            NSAttributedString.Key.font: boldFont!,
            NSAttributedString.Key.foregroundColor: UIColor.black]))
        
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(pushSearch))
        self.navigationItem.rightBarButtonItem = searchButton
        
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton
        
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    
    }
    
    @objc func pushSearch(){
//        AuthService.logout(onSuccess: {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
//            self.navigationController?.pushViewController(controller, animated: true)
//        }) { (error) in
//            print(error)
//        }
        StorageCacheController.shared.clearUser()
    }
    
}
