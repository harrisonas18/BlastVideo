//
//  Api.swift
//  Blast Video
//
//  Created by Harrison Senesac
//  Copyright © 2018 Harrison Senesac All rights reserved.
//

import Foundation
struct Api {
    static var User = UserApi()
    static var Post = PostApi()
    static var Post_Comment = Post_CommentApi()
    static var MyPosts = MyPostsApi()
    static var Feed = FeedApi()
    static var HashTag = HashTagApi()
    static var Favorites = FavoritesApi()
    static var Follow = FollowApi()
    static var Auth = AuthService()
    static var Upload = UploadService()
    static var Helper = HelperService()
    static var Notification = NotificationApi()
    static var Delete = DeleteFilesAPI()
    
}
