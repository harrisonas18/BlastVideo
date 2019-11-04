//
//  PhotoFeedModel.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 2/4/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation

final class PhotoFeedModel {
    
    public private(set) var photoFeedModelType: PhotoFeedModelType
    
    var feedPosts: [Post] = []
    var feedUsers: [UserObject] = []
    private var fetchPageInProgress: Bool = false
    
    // MARK: Lifecycle
    
    init(photoFeedModelType: PhotoFeedModelType) {
        self.photoFeedModelType = photoFeedModelType
    }
    
    // MARK: API
    var numberOfItems: Int {
        return feedPosts.count
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> Post {
        return feedPosts[indexPath.item]
    }
    
    // return in completion handler the number of additions and the status of internet connection
    
    
} //End of Class

enum PhotoFeedModelType {
    case photoFeedModelTypeRecent
    case photoFeedModelTypePopular
    case photoFeedModelTypeUserPhotos
}
