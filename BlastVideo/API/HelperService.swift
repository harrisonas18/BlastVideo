//
//  HelperService.swift
//  Blast Video
//
//  Created by Harrison Senesac
//  Copyright © 2018 Harrison Senesac All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class HelperService {
    
    func uploadDataToServer(data: Data, videoUrl: URL? = nil, ratio: Float, caption: String, onSuccess: @escaping () -> Void) {
        if let videoUrl = videoUrl {
            self.uploadVideoToFirebaseStorage(videoUrl: videoUrl, onSuccess: { (videoUrl) in
                self.uploadImageToFirebaseStorage(data: data, onSuccess: { (thumbnailImageUrl) in
                    self.sendDataToDatabase(photoUrl: thumbnailImageUrl, videoUrl: videoUrl, ratio: ratio, caption: caption, onSuccess: onSuccess)
                })
            })
            
        } else {
            uploadImageToFirebaseStorage(data: data) { (photoUrl) in
                self.sendDataToDatabase(photoUrl: photoUrl, ratio: ratio, caption: caption, onSuccess: onSuccess)
            }
        }
    }
    
    func uploadVideoToFirebaseStorage(videoUrl: URL, onSuccess: @escaping (_ videoUrl: String) -> Void) {
        let videoIdString = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(videoIdString)
        storageRef.putFile(from: videoUrl, metadata: nil) { (metadata, error) in
            if error != nil {
                //ProgressHUD.showError(error!.localizedDescription)
                print(error!.localizedDescription)
                return
            }
            var videoURL: String = ""
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    print("Error could not retrieve URL")
                    return
                }
                videoURL = downloadURL.absoluteString
                onSuccess(videoURL)
            }
        }
    }
    
    func uploadImageToFirebaseStorage(data: Data, onSuccess: @escaping (_ imageUrl: String) -> Void) {
        let photoIdString = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(photoIdString)
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                //ProgressHUD.showError(error!.localizedDescription)
                return
            }
            var photoURL: String = ""
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    print("Error could not retrieve URL")
                    return
                }
                photoURL = downloadURL.absoluteString
                onSuccess(photoURL)
            }

            
        }
    }
    
    func sendDataToDatabase(photoUrl: String, videoUrl: String? = nil, ratio: Float, caption: String, onSuccess: @escaping () -> Void) {
        let newPostId = Api.Post.REF_POSTS.childByAutoId().key
        let newPostReference = Api.Post.REF_POSTS.child(newPostId!)
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let currentUserId = currentUser.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        
//        let words = caption.components(separatedBy: CharacterSet.whitespacesAndNewlines)
//        
//        for var word in words {
//            if word.hasPrefix("#") {
//                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
//                let newHashTagRef = Api.HashTag.REF_HASHTAG.child(word.lowercased()).child(newPostId!)
//                newHashTagRef.setValue(["timestamp": timestamp])
//            }
//        }
        
        var dict = ["uid": currentUserId ,"photoUrl": photoUrl, "caption": caption, "likeCount": 0, "ratio": ratio, "timestamp": timestamp] as [String : Any]
        if let videoUrl = videoUrl {
            dict["videoUrl"] = videoUrl
        }
        
        newPostReference.setValue(dict, withCompletionBlock: {
            (error, ref) in
            if error != nil {
                //ProgressHUD.showError(error!.localizedDescription)
                print("Error uploading new post reference")
                return
            }
            
            Api.Feed.REF_FEED.child(Auth.auth().currentUser!.uid).child(newPostId!)
                .setValue(["timestamp": timestamp])
            
            let myPostRef = Api.MyPosts.REF_MYPOSTS.child(currentUserId).child(newPostId!)
            myPostRef.setValue(["timestamp": timestamp], withCompletionBlock: { (error, ref) in
                if error != nil {
                    //ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            })
            //ProgressHUD.showSuccess("Success")
            onSuccess()
        })
    }
}
