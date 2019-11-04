//
//  DiscoverDataSource.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/30/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class DiscoverDataSource: NSObject, ASCollectionDataSource, PushUsernameDelegate  {
    func pushUser(user: UserObject) {
        let detailViewController = ViewProfileController(user: user)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    var posts: [Post] = []
    var users: [UserObject] = []
    var newPhotos = 0
    var isLoadingPost = false
    var isPostView = true
    var headerNode: ProfileHeaderNode?
    
    override init() {
        super.init()
        fetchPosts()
    }
    
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        let cell = DiscoverCellNode(post: post, user: user)
        cell.contentNode.delegate = self
        return cell
    }
    
    func fetchPosts() {
        Api.Post.getRecentPost(start: posts.first?.timestamp, limit: 8) { (results) in
            if results.count > 0 {
                results.forEach({ (result) in
                    self.posts.append(result.0)
                    self.users.append(result.1)
                })
            }
        }
    }
    
    func fetchMorePosts() {
        Api.MyPosts.getProfilePosts(userId: currentUserGlobal.id!, start: posts.first?.timestamp, limit: 8) { (results) in
            if results.count > 0 {
                results.forEach({ (result) in
                    self.posts.append(result)
                })
            }
        }
    }
    
}
