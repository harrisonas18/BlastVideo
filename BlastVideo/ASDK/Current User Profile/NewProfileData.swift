//
//  NewProfileData.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/11/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
//TODO: Fix data to be dynamic based on the user - currently only allows current user global var
//Needs to be any user with the user object being passed
import Foundation
import IGListKit

class NewProfileData: NSObject {
    static let shared = NewProfileData()
    var isLoadingPost = false
    var firstFetchPosts = true
    var firstFetchFavs = true
    var newItems = 0
    
    var feedItems: [FeedItem] = [FeedItem]()
    var favFeedItems: [FeedItem] = [FeedItem]()
    
    //Fetches Current users posts - based on timestamp in descending order
    func fetchUserPosts(user: UserObject, limit: UInt, completion: @escaping ([FeedItem]) -> Void) {
        if isLoadingPost {
            return
        }
        if limit == 0 {
            firstFetchPosts = false
            self.isLoadingPost = true
            completion(self.feedItems)
        } else {
            firstFetchPosts = false
            self.isLoadingPost = true
            Api.MyPosts.getProfilePosts(userId: user.id!, start: nil, limit: limit) { (results) in
                print("Profile posts count", results.count)
                self.isLoadingPost = false
                if results.count > 0 {
                    results.forEach({ (result) in
                        let item = FeedItem(id: result.id!, post: result, user: user)
                        self.feedItems.append(item)
                    })
                } else {
                    return
                }
                self.newItems = results.count
                completion(self.feedItems)
            }
        }
        
    }
    
    //Fetches more current user posts
    func fetchMoreUserPosts(user: UserObject, completion: @escaping ([FeedItem]) -> Void) {
        if isLoadingPost {
            return
        }
        self.isLoadingPost = true
        guard let lastPostTimestamp = feedItems.last?.post.timestamp else {
            self.isLoadingPost = false
            return
        }
        Api.MyPosts.getOlderProfilePosts(userId: user.id!, start: lastPostTimestamp, limit: 8) { (results) in
            if results.count == 0 {
                return
            }
            self.newItems = results.count
            for result in results {
                let item = FeedItem(id: result.id!, post: result, user: currentUserGlobal)
                self.feedItems.append(item)
            }
            self.isLoadingPost = false
        }
        completion(self.feedItems)
    }
    
    //Fetches Current users posts - based on timestamp in descending order
    func fetchUserFavs(user: UserObject, limit: UInt, completion: @escaping ([FeedItem]) -> Void) {
//        if isLoadingPost {
//            print("Currently Loading")
//            return
//        }
        if limit == 0 {
            self.isLoadingPost = false
            firstFetchPosts = false
            completion(self.favFeedItems)
        } else {
            firstFetchPosts = false
            self.isLoadingPost = true
            Api.Favorites.getFavorites(userId: user.id ?? "", start: favFeedItems.first?.post.timestamp, limit: limit) { (results) in
                self.isLoadingPost = false
                if results.count > 0 {
                    results.forEach({ (result) in
                        let item = FeedItem(id: result.0.id!, post: result.0, user: result.1)
                        self.favFeedItems.append(item)
                    })
                } else {
                    return
                }
                self.newItems = results.count
                completion(self.favFeedItems)
            }
        }
        
    }
    
    //Fetches more current user posts
    func fetchMoreUserFavs(user: UserObject, completion: @escaping ([FeedItem]) -> Void) {
        if isLoadingPost {
            return
        }
        self.isLoadingPost = true
        guard let lastPostTimestamp = favFeedItems.last?.post.timestamp else {
            self.isLoadingPost = false
            return
        }
        Api.MyPosts.getOlderProfilePosts(userId: user.id ?? "", start: lastPostTimestamp, limit: 8) { (results) in
            if results.count == 0 {
                return
            }
            self.newItems = results.count
            for result in results {
                let item = FeedItem(id: result.id!, post: result, user: currentUserGlobal)
                self.favFeedItems.append(item)
            }
            self.isLoadingPost = false
        }
        completion(self.feedItems)
    }
    
    
    
}
