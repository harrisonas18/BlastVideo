//
//  NotificationData.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 11/21/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation

class NotificationData: NSObject {
    
    static let shared = DiscoverData()
    
    var firstFetch = true
    var posts: [Post] = []
    var users: [UserObject] = []
    var isLoadingPost = false
    var newItems = 0
    var feedItems: [FeedItem] = [FeedItem]()
    
    
    
}
