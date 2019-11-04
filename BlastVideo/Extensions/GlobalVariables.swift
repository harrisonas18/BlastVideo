//
//  Constants.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 2/6/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation

//The user object of the current user
var currentUserGlobal = UserObject()

//Delegates
//Tracks when a username was tapped and pushes corresponding User profile view controller
protocol PushUsernameDelegate {
    func pushUser(user: UserObject)
}
//Tracks when the index of the user profile segmented control was tapped
protocol UserProfileHeaderDelegate {
    func trackSelectedIndex(_ theSelectedIndex: Int)
}

//Pushes collection view with posts that have corresponding Hashtag
protocol PushHashtagDelegate {
    func pushHashtag(hashtag: String)
}

//Pushes Detail View Controller of post when tapped
protocol PushViewControllerDelegate {
    func pushViewController(post: Post, user: UserObject)
}

protocol EnableScrollDelegate {
    func changeScrollState(shouldChange: Bool)
}

protocol ScrollViewToTopDelegate {
    func shouldScrollToTop(shouldScroll: Bool)
}
