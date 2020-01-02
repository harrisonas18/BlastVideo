//
//  StorageCacheController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 3/14/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import PhotosUI
import Photos
import Disk
import NotificationBannerSwift
import Cache

class StorageCacheController: NSObject {
    
    //  MARK: Variables
    static let shared = StorageCacheController()
    
    //  Variable - CurrentUser: UserObject
    var currentUser = UserObject()
    //Stores Live Photo objects that have been assembled
    var livePhotoCache = NSCache<NSString, PHLivePhoto>()
    
    //Config for Posts Cache
    let diskConfig = DiskConfig(name: "Posts", expiry: .never, maxSize: 10000, directory: nil, protectionType: FileProtectionType.none)
    let memoryConfig = MemoryConfig(expiry: .never, countLimit: 100, totalCostLimit: 10000)
    
    
    
    //  Check to see if Read/Write is in progress
    private var inProgress: Bool = false
    
    //  Queue variable to manage read/write operations
    private let concurrentPhotoQueue = DispatchQueue(
        label: "com.harrison.LiveMe.CurrentUserQueue",
        attributes: .concurrent)
    
    override init() {
        super.init()
        livePhotoCache.totalCostLimit = 10000000
    }
    
    let dataStorage = try! Storage(
      diskConfig: DiskConfig(name: "User", expiry: .never, maxSize: 10000, directory: nil, protectionType: FileProtectionType.none),
      memoryConfig: MemoryConfig(expiry: .never, countLimit: 100, totalCostLimit: 10000),
      transformer: TransformerFactory.forData()
    )
    
    func saveUser(user: UserObject){
        let userItemStorage = dataStorage.transformCodable(ofType: UserObject.self)
        
        do {
            try userItemStorage.setObject(user, forKey: user.id ?? "")
        } catch let error as NSError {
            self.inProgress = false
            fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
        
    }
    
    func updateUser(user: UserObject){
        let userItemStorage = dataStorage.transformCodable(ofType: UserObject.self)
        
        do {
            try userItemStorage.setObject(user, forKey: user.id ?? "")
        } catch let error as NSError {
            self.inProgress = false
            fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
        
    }
    
    func retrieveUser(user: UserObject) -> UserObject?{
        let userItemStorage = dataStorage.transformCodable(ofType: UserObject.self)
        
        do {
            let object = try userItemStorage.existsObject(forKey: user.id ?? "")
            if object {
                do {
                    return try userItemStorage.object(forKey: user.id ?? "")
                } catch let error as NSError {
                    self.inProgress = false
                    fatalError("""
                        Domain: \(error.domain)
                        Code: \(error.code)
                        Description: \(error.localizedDescription)
                        Failure Reason: \(error.localizedFailureReason ?? "")
                        Suggestions: \(error.localizedRecoverySuggestion ?? "")
                        """)
                }
            } else {
                return nil
            }
        } catch let error as NSError {
            self.inProgress = false
            fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
        
    }
    
    func deleteUser(user: UserObject){
        let userItemStorage = dataStorage.transformCodable(ofType: UserObject.self)
        
        do {
            try userItemStorage.setObject(user, forKey: user.id ?? "")
        } catch let error as NSError {
            self.inProgress = false
            fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
        
    }
    
    func saveFeedItem(feedItem: FeedItem){
        let feedItemStorage = dataStorage.transformCodable(ofType: FeedItem.self)
        
        do {
            try feedItemStorage.setObject(feedItem, forKey: feedItem.id)
        } catch let error as NSError {
            self.inProgress = false
            fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
    }
    
    func retrieveFeedItem(feedItem: FeedItem) -> FeedItem?{
        let feedItemStorage = dataStorage.transformCodable(ofType: FeedItem.self)
        
        do {
            let object = try feedItemStorage.existsObject(forKey: feedItem.id)
            if object {
                do {
                     return try feedItemStorage.object(forKey: feedItem.id)
                } catch let error as NSError {
                    self.inProgress = false
                    fatalError("""
                        Domain: \(error.domain)
                        Code: \(error.code)
                        Description: \(error.localizedDescription)
                        Failure Reason: \(error.localizedFailureReason ?? "")
                        Suggestions: \(error.localizedRecoverySuggestion ?? "")
                        """)
                }
            } else {
                return nil
            }
        } catch let error as NSError {
            self.inProgress = false
            fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
        
        
    }
    
    //  Variable - CurrentUserPosts: [Posts]
    //  Variable - CurrentUserFavorites: [Posts]
    
    /*--------------------------------------------------------------------------------------*/
    //  MARK: Methods
    //  Saves current User to disk
    public func saveCurrentUser(user: UserObject) {
        guard !inProgress else {
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            self.inProgress = true
            do {
                try Disk.save(user, to: .documents, as: "CurrentUser/user.json")
                self.inProgress = false
            } catch let error as NSError {
                self.inProgress = false
                fatalError("""
                    Domain: \(error.domain)
                    Code: \(error.code)
                    Description: \(error.localizedDescription)
                    Failure Reason: \(error.localizedFailureReason ?? "")
                    Suggestions: \(error.localizedRecoverySuggestion ?? "")
                    """)
            }
        }
        
    }//End Function
    /*--------------------------------------------------------------------------------------*/
    
    //  Retrieve Current User from Disk
    public func retrieveCurrentUser(completion: @escaping (UserObject) -> Void) {
        guard !inProgress else {
            return
        }
        inProgress = true
        do {
            let user = try Disk.retrieve("CurrentUser/user.json", from: .documents, as: UserObject.self)
            completion(user)
            inProgress = false
        } catch let error as NSError {
            inProgress = false
            fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
    }//End Function
    
    /*-----------------------------------------------------------------------------------*/
    // 1. See if files are already saved to disk
    // 2. If not fetch from Network
    // 3. Save to disk
    // 4. Return Live Photo Video and Photo URLS to make LivePhoto Object
    let livePhotoQueue = DispatchQueue(label: "com.harrison.LivePhotoQueue")
    public func retrieveLivePhoto(post: Post, completion: @escaping (PHLivePhoto) -> Void ) {
        
        //TODO: Throw error message to UI
        guard let id = post.uniformTypeID else { return }
        let videoURL = "\(id)/video.mov"
        //1. if video exists retrieve from file system
        if Disk.exists(videoURL, in: .caches){
                //Retrieve file URLS
                //Call retrieveFileURLS
                retrieveFileURLS(post: post) { (videoURL, photoURL) in
                    PHLivePhoto.request(withResourceFileURLs: [videoURL, photoURL], placeholderImage: nil, targetSize: .zero, contentMode: .aspectFill) { (livePhoto, info) in

                        if let livePhoto = livePhoto {
                            completion(livePhoto)
                            self.livePhotoCache.setObject(livePhoto, forKey: post.id! as NSString)
                        } else {
                            for (key, value) in info {
                                //print("Key: ", key, "Value: ", value)
                                if let error = info[PHLivePhotoInfoErrorKey] as? NSError {
                                    print(error.localizedDescription)
                                }
                            }
                            print("""
                            Error Retrieving Live Photo
                            Trace: Could not create Live Photo
                            """)
                        }
                    }
                }
            
        } else {
            // If video doesnt exist Fetch from network
            // Call saveLivePhoto() to download to disk
            saveLivePhoto(post: post) { (success) in
                if success {
                    self.retrieveFileURLS(post: post, completion: { (videoURL, photoURL) in
                        PHLivePhoto.request(withResourceFileURLs: [videoURL, photoURL], placeholderImage: nil, targetSize: .zero, contentMode: .aspectFill) { (livePhoto, info) in
                            if let livePhoto = livePhoto {
                                completion(livePhoto)
                                self.livePhotoCache.setObject(livePhoto, forKey: post.id! as NSString)
                            } else {
                                for (key, value) in info {
                                    print("Key: ", key, "Value: ", value)
                                    print("Key: ", key, "Description: ", key.description)
                                    if let error = info[PHLivePhotoInfoErrorKey] as? NSError {
                                        print(error)
                                    }
                                }

                                print("""
                                Error Retrieving Live Photo
                                Trace: Could not create Live Photo
                                """)
                            }
                        }
                    })
                } else {
                    print("Error occurred downloading/saving data")
                }
            }
        }
        
    }//End Function
    /*-------------------------------------------------------------------------------------------------*/
    
    // 1. Download Files from Post Vide and Photo URLS
    //    Save to file system folder
    //    Folder naming convention - folder name = PostID/video.mp4
    //                                             PostID/photo.jpg
    //    These two resources constitute the live photo
    // 2. Return two file urls to be used in the construction of Live Photo
    // Completion: Returns true if everything executed correctly, false if error throw
    func saveLivePhoto(post: Post, completion: @escaping (Bool) -> Void) {
        
        var success: Bool = true
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "saveDispatchQueue", qos: .userInitiated)
        
        let tmpVideoURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        .appendingPathComponent("\(post.uniformTypeID!)/video")
        .appendingPathExtension("mov")
              
        let tmpPhotoURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        .appendingPathComponent("\(post.uniformTypeID!)/photo")
        .appendingPathExtension("jpeg")
    
        
        //TODO: Throw error message to UI
        group.enter()
        guard let videoURL = URL(string: post.videoUrl ?? "") else { return }
        do {
            let videoData = try Data(contentsOf: videoURL, options: [])
            do {
                try Disk.save(videoData, to: .caches , as: "\(post.uniformTypeID!)/video.mov")
                group.leave()
            } catch let error as NSError {
                //TODO: Throw error to UI
                group.leave()
                success = false
                completion(success)
                fatalError("""
                    Domain: \(error.domain)
                    Code: \(error.code)
                    Description: \(error.localizedDescription)
                    Failure Reason: \(error.localizedFailureReason ?? "")
                    Suggestions: \(error.localizedRecoverySuggestion ?? "")
                    """)
            }
        } catch let error as NSError {
            //TODO: Throw error to UI
            group.leave()
            success = false
            completion(success)
            fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
        //TODO: Throw error message to UI
        group.enter()
        guard let photoURL = URL(string: post.photoUrl ?? "") else { return }
        do {
            let photoData = try Data(contentsOf: photoURL, options: [])
            do {
                try Disk.save(photoData, to: .caches , as: "\(post.uniformTypeID!)/photo.jpeg")
                group.leave()
            } catch let error as NSError {
                //TODO: Throw error to UI
                group.leave()
                success = false
                completion(success)
                fatalError("""
                    Domain: \(error.domain)
                    Code: \(error.code)
                    Description: \(error.localizedDescription)
                    Failure Reason: \(error.localizedFailureReason ?? "")
                    Suggestions: \(error.localizedRecoverySuggestion ?? "")
                    """)
            }
        } catch let error as NSError {
            //TODO: Throw error to UI
            group.leave()
            success = false
            completion(success)
            fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
        //Completion Returns true if everything executed correctly, false if error throw
        group.notify(queue: queue) {
            print("Save Live Photo Data Successful")
            completion(success)
        }
    }//End Function
    /*--------------------------------------------------------------------------------------*/
    
    /*--------------------------------------------------------------------------------------*/
    // 1. Retrieves file URLs from Disk if URLs exist
    func retrieveFileURLS(post: Post, completion: @escaping (URL, URL)->Void) {
        //Returned File URLs that make up Live Photo
        var fileVideoURL: URL?
        var filePhotoURL: URL?
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "dispatchQueue", qos: .userInitiated)
        
        group.enter()
        do {
            let videoURL = try Disk.url(for: "\(post.uniformTypeID!)/video.mov", in: .caches)
            fileVideoURL = videoURL
            group.leave()
        } catch let error as NSError {
             group.leave()
            //inProgress = false
            fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
        
        group.enter()
        do {
            let photoURL = try Disk.url(for: "\(post.uniformTypeID!)/photo.jpeg", in: .caches)
            filePhotoURL = photoURL
            group.leave()
        } catch let error as NSError {
             group.leave()
            //inProgress = false
            fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
        
        group.notify(queue: queue) {
            print("Retrieve File URLs Successful")
            completion(fileVideoURL!, filePhotoURL!)
        }
        
    }//End Function
    
    /*--------------------------------------------------------------------------------------*/
    
    func clearUser(){
        do {
            try Disk.remove("CurrentUser/user.json", from: .documents)
            print("caches cleared")
        } catch let error as NSError {
            //inProgress = false
            fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
    }
    
}//End of Class Definition

//  MARK: Variables

//  CacheKey identifies resource cached to filesystem for retrieval and removal
//  Variable - CacheKey: String

//  MARK: Methods
//  Method - Cache LivePhoto Video to Filesystem
//  Method - Clear Cached LivePhoto Video from Filesystem
//
//  Method - Cache LivePhoto Picture to Filesystem
//  Method - Clear Cached LivePhoto Picture from Filesystem

//  Clears the Current User Variable
