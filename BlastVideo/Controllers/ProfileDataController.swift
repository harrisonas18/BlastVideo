//
//  ProfileDataController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 4/13/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//
//
//  Contains methods to manage the retrieval of Current User Profile Data
//
//
import Foundation
import AsyncDisplayKit

class ProfileDataController: NSObject {
    
    var userPosts: [Post] = []
    var userFavorites: [Post] = []
    var userFavoriteUsers: [UserObject] = []
    var user = UserObject()
    var newPhotos = 0
    var isLoadingPost = false
    var firstFetchPosts = true
    var firstFetchFavs = true
    
    
    static let sharedInstance = ProfileDataController()
    
    
    func fetchPostBatch() {
        
        if firstFetchPosts {
            firstFetchPosts = false
            self.isLoadingPost = true
            
            Api.MyPosts.getProfilePosts(userId: currentUserGlobal.id!, start: userPosts.first?.timestamp, limit: 8) { (results) in
                if results.count > 0 {
                    results.forEach({ (result) in
                        self.userPosts.append(result)
                    })
                }
                self.newPhotos = results.count
                self.isLoadingPost = false
            }
            
        } else {
            guard !self.isLoadingPost else {

                return
            }
            self.isLoadingPost = true
            
            guard let lastPostTimestamp = userPosts.last?.timestamp else {
                self.isLoadingPost = false
                return
            }
            Api.MyPosts.getOlderProfilePosts(userId: currentUserGlobal.id!, start: lastPostTimestamp, limit: 8) { (results) in
                if results.count == 0 {
                    return
                }
                for result in results {
                    self.userPosts.append(result)
                }
                self.newPhotos = results.count
                self.isLoadingPost = false
                
            }
        }
    }
    
    func fetchFavBatch() {
        
        if firstFetchFavs {
            firstFetchFavs = false
            self.isLoadingPost = true
            
            Api.Favorites.getFavorites(userId: currentUserGlobal.id!, start: userFavorites.first?.timestamp, limit: 8) { (results) in
                if results.count > 0 {
                    results.forEach({ (result) in
                        self.userFavorites.append(result.0)
                        self.userFavoriteUsers.append(result.1)
                    })
                }
                self.newPhotos = results.count
                self.isLoadingPost = false
            }
            
        } else {
            guard !self.isLoadingPost else {
                return
            }
            self.isLoadingPost = true
            
            guard let lastPostTimestamp = userFavorites.last?.timestamp else {
                self.isLoadingPost = false
                return
            }
            Api.Favorites.getOlderFavorites(userId: currentUserGlobal.id!, start: lastPostTimestamp, limit: 8) { (results) in
                if results.count == 0 {
                    return
                }
                for result in results {
                    self.userFavorites.append(result.0)
                    self.userFavoriteUsers.append(result.1)
                }
                self.newPhotos = results.count
                self.isLoadingPost = false
            }
        }
    }
    
    func clearData(){
        userPosts = []
        userFavorites = []
        userFavoriteUsers = []
        newPhotos = 0
    }

    
}
