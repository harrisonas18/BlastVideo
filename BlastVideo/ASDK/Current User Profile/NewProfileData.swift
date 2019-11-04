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
    
    var isLoadingPost = false
    var firstFetchPosts = true
    var firstFetchFavs = true
    
    var feedItems: [FeedItem] = [FeedItem]()
    var favFeedItems: [FeedItem] = [FeedItem]()
    
    static let shared = NewProfileData()
    
    //Fetches Current users posts - based on timestamp in descending order
    func fetchUserPosts(user: UserObject, completion: @escaping ([FeedItem]) -> Void) {
        if isLoadingPost {
            return
        }
        firstFetchPosts = false
        self.isLoadingPost = true
        Api.MyPosts.getProfilePosts(userId: "7Fg8SurjSoh5y7J8g7gjNna45Rp2", start: nil, limit: 8) { (results) in
            self.isLoadingPost = false
            if results.count > 0 {
                results.forEach({ (result) in
                    let item = FeedItem(id: result.id!, post: result, user: user)
                    self.feedItems.append(item)
                })
            } else {
                return
            }
            completion(self.feedItems)
        }
    }
    
    //Fetches more current user posts
    func fetchMoreUserPosts(userID: UserObject, completion: @escaping ([FeedItem]) -> Void) {
        if isLoadingPost {
            return
        }
        self.isLoadingPost = true
        guard let lastPostTimestamp = feedItems.last?.post.timestamp else {
            self.isLoadingPost = false
            return
        }
        Api.MyPosts.getOlderProfilePosts(userId: currentUserGlobal.id!, start: lastPostTimestamp, limit: 8) { (results) in
            if results.count == 0 {
                return
            }
            for result in results {
                let item = FeedItem(id: result.id!, post: result, user: currentUserGlobal)
                self.feedItems.append(item)
            }
            self.isLoadingPost = false
        }
        completion(self.feedItems)
    }
    
    //Fetches Current users posts - based on timestamp in descending order
    func fetchUserFavs(userID: UserObject, completion: @escaping ([FeedItem]) -> Void) {
//        if isLoadingPost {
//            print("Currently Loading")
//            return
//        }
        firstFetchPosts = false
        self.isLoadingPost = true
        print("Favs Fired")
        Api.Favorites.getFavorites(userId: userID.id ?? "", start: favFeedItems.first?.post.timestamp, limit: 8) { (results) in
            self.isLoadingPost = false
            if results.count > 0 {
                results.forEach({ (result) in
                    let item = FeedItem(id: result.0.id!, post: result.0, user: result.1)
                    self.favFeedItems.append(item)
                })
            } else {
                return
            }
            completion(self.favFeedItems)
        }
    }
    
    //Fetches more current user posts
    func fetchMoreUserFavs(userID: UserObject, completion: @escaping ([FeedItem]) -> Void) {
        if isLoadingPost {
            return
        }
        self.isLoadingPost = true
        guard let lastPostTimestamp = favFeedItems.last?.post.timestamp else {
            self.isLoadingPost = false
            return
        }
        Api.MyPosts.getOlderProfilePosts(userId: userID.id ?? "", start: lastPostTimestamp, limit: 8) { (results) in
            if results.count == 0 {
                return
            }
            for result in results {
                let item = FeedItem(id: result.id!, post: result, user: currentUserGlobal)
                self.favFeedItems.append(item)
            }
            self.isLoadingPost = false
        }
        completion(self.feedItems)
    }
    
    
    
}
