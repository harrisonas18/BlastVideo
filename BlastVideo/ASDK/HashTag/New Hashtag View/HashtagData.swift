//
//  HashtagData.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/17/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
import Foundation
import IGListKit

class HashtagData: NSObject {
    
    static let shared = HashtagData()
    
    var firstFetch = true
    var posts: [Post] = []
    var users: [UserObject] = []
    var isLoadingPost = false
    var newItems = 0
    var feedItems: [FeedItem] = [FeedItem]()
    
    func fetchPosts(hashtag: String, completion: @escaping ([FeedItem]) -> Void) {
        if isLoadingPost {
            return
        }
        isLoadingPost = true
        Api.HashTag.getHashtagPosts(hashtag: hashtag, limit: 8) { (results) in
            self.firstFetch = false
            self.isLoadingPost = false
            if results.count > 0 {
                results.forEach({ (result) in
                    let item = FeedItem(id: result.0.id!, post: result.0, user: result.1)
                    self.feedItems.append(item)
                })
            } else {
                print("Results is zero")
                return
            }
            self.newItems = results.count
            completion(self.feedItems)
        }
    }
    
    func fetchMorePosts(hashtag: String, completion: @escaping ([FeedItem]) -> Void) {
        guard let lastPostTimestamp = feedItems.last?.post.timestamp else {
            isLoadingPost = false
            return
        }
        if isLoadingPost {
            return
        }
        isLoadingPost = true
        Api.HashTag.getMoreHashtagPosts(hashtag: hashtag, start: lastPostTimestamp, limit: 8) { (results) in
            self.isLoadingPost = false
            if results.count == 0 {
                self.newItems = results.count
                return
            }
            self.newItems = results.count
            for result in results {
                let item = FeedItem(id: result.0.id!, post: result.0, user: result.1)
                self.feedItems.append(item)
            }
        }
        completion(self.feedItems)
    }
    
}
