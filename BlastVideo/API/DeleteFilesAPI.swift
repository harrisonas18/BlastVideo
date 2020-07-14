//
//  DeleteFilesAPI.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 7/12/20.
//  Copyright © 2020 Harrison Senesac. All rights reserved.
//
import Foundation
import FirebaseDatabase
import NotificationBannerSwift
import FirebaseAuth

class DeleteFilesAPI {
    var REF_POSTS = Database.database().reference().child("posts").child("posts")
    
    func deletePost(post: Post) {
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        if currentUser.uid == post.uid {
            let ref = REF_POSTS.child(post.id!)
            
            ref.removeValue { (error, ref) in
                if error == nil {
                    let success = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Post Removed", attributes: [:]), style: .success, colors: nil)
                    success.duration = 3.0
                    success.show()
                } else {
                    let error = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Error Removing Post", attributes: [:]), style: .danger, colors: nil)
                    error.duration = 3.0
                    error.show()
                }
            }
        } else {
            let error = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Error Removing Post", attributes: [:]), style: .danger, colors: nil)
            error.duration = 3.0
            error.show()
        }
    }
    
    
}//end class
