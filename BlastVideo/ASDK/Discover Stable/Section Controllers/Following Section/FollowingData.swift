//
//  FollowingData.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/29/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
import Foundation
import IGListKit

class FollowingData: NSObject {
    
    static let shared = FollowingData()
    
    var firstFetch = true
    var posts: [Post] = []
    var users: [UserObject] = []
    var isLoadingPost = false
    var newItems = 0
    var feedItems: [FeedItem] = [FeedItem]()

    func fetchPosts(with id: String, limit: UInt, completion: @escaping ([FeedItem]) -> Void) {
        if isLoadingPost {
            return
        }
        
        if limit == 0 {
            isLoadingPost = false
            completion(self.feedItems)
        } else {
            isLoadingPost = true
            Api.Feed.getRecentFeed(withId: id, limit: limit) { (results) in
                self.firstFetch = false
                self.isLoadingPost = false
                print("got feed")
                if results.count > 0 {
                    results.forEach({ (result) in
                        let item = FeedItem(id: result.0.id!, post: result.0, user: result.1)
                        self.feedItems.append(item)
                    })
                }
                print("My Feed Results: ", results.count)
                self.newItems = results.count
                completion(self.feedItems)
            }
        }
        
    }
    
    func fetchMorePosts(completion: @escaping ([FeedItem]) -> Void) {
        guard let lastPostTimestamp = feedItems.last?.post.timestamp else {
            isLoadingPost = false
            return
        }
        if isLoadingPost {
            return
        }
        isLoadingPost = true
        Api.Feed.getOldFeed(withId: currentUserGlobal.id ?? "", start: lastPostTimestamp, limit: 8) { (results) in
            self.isLoadingPost = false
            if results.count == 0 {
                self.newItems = results.count
                return
            }
            for result in results {
                let item = FeedItem(id: result.0.id!, post: result.0, user: result.1)
                self.feedItems.append(item)
            }
            self.newItems = results.count
        }
        completion(self.feedItems)
    }
    
}
