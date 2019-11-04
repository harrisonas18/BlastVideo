//
//  PostsDataSource.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/28/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class PostsDataSource: NSObject, ASCollectionDataSource {
    
    var posts: [Post] = []
    var newPhotos = 0
    var isLoadingPost = false
    var isPostView = true
    var headerNode: ProfileHeaderNode?
    
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        
        if kind == UICollectionView.elementKindSectionHeader {
            return headerNode!
        } else {
            assert(false, "Invalid Header Type")
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let post = self.posts[indexPath.row]
        return CollectionPostCellNode(post: post, user: nil)
    }
    
    func fetchPosts(completion: @escaping () -> Void) {
        Api.MyPosts.getProfilePosts(userId: currentUserGlobal.id!, start: posts.first?.timestamp, limit: 8) { (results) in
            if results.count > 0 {
                results.forEach({ (result) in
                    self.posts.append(result)
                })
            }
            completion()
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
