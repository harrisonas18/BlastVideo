//
//  DiscoverData.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/30/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
//
//  Problem: Refreshing data need to call latest posts then merge results with post array
//  Need to diff instead of append posts to see what posts are the same
//  Current error is getting thrown when appending posts and then two or more posts
//  with same id are trying to be diffed
//
//
import Foundation
import IGListKit

class DiscoverData: NSObject {
    
    static let shared = DiscoverData()
    
    var firstFetch = true
    var posts: [Post] = []
    var users: [UserObject] = []
    var isLoadingPost = false
    var newItems = 0
    var feedItems: [FeedItem] = [FeedItem]()
    

    func fetchPosts(limit: UInt, completion: @escaping ([FeedItem]) -> Void) {
        if isLoadingPost {
            return
        }
        if limit == 0 {
            isLoadingPost = false
            completion(self.feedItems)
        } else {
            isLoadingPost = true
            Api.Post.getRecentPost(limit: limit) { (results) in
                self.firstFetch = false
                self.isLoadingPost = false
                if results.count > 0 {
                    results.forEach({ (result) in
                        let item = FeedItem(id: result.0.id!, post: result.0, user: result.1)
                        self.feedItems.append(item)
                    })
                }
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
        Api.Post.getOldPost(start: lastPostTimestamp, limit: 8) { (results) in
            self.isLoadingPost = false
            if results.count == 0 {
                self.newItems = results.count
                completion(self.feedItems)
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
