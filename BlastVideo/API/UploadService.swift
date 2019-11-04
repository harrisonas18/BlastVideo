//
//  UploadService.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/25/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class UploadService {

    //Upload Post Helper function
    static func uploadPost(photoURL: URL, videoURL: URL, ratio: Float, caption: String, completion: @escaping () -> Void){
        
        var photoString : String = ""
        var videoString : String = ""
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "dispatchQueue", qos: .userInitiated)
        
        group.enter()
        print("photo upload called")
        uploadPhoto(photoURL: photoURL, completion: { (photoURLString) in
            photoString = photoURLString
            print("photo uploaded")
            group.leave()
        })
        
        group.enter()
        print("video upload called")
        uploadVideo(videoURL: videoURL, completion: { (videoURLString) in
            videoString = videoURLString
            print("video uploaded")
            group.leave()
        })
        
        group.notify(queue: queue) {
            print("post upload called")
            uploadPostData(photoUrl: photoString, videoUrl: videoString, ratio: ratio , caption: caption, completion: {
                print("post uploaded")
                completion()
            })
        }
    }
    
    //Upload Video
    private static func uploadVideo(videoURL: URL, completion: @escaping (_ videoURL: String) -> Void){
        let videoIdString = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(videoIdString)
        storageRef.putFile(from: videoURL, metadata: nil) { (metadata, error) in
            if error != nil {
                //ProgressHUD.showError(error!.localizedDescription)
                print(error!.localizedDescription)
                return
            }
            var videoURLString: String = ""
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    print("Error could not retrieve Video URL")
                    return
                }
                videoURLString = downloadURL.absoluteString
                completion(videoURLString)
            }
        }
    }
    
    //Upload Photo
    private static func uploadPhoto(photoURL: URL, completion: @escaping (_ photoURL: String) -> Void){
        let photoIdString = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(photoIdString)
        storageRef.putFile(from: photoURL, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            var photoURLString: String = ""
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    print("Error could not retrieve Photo URL")
                    return
                }
                photoURLString = downloadURL.absoluteString
                completion(photoURLString)
            }
        }
    }
    
    //Upload Post Data to database
    private static func uploadPostData(photoUrl: String, videoUrl: String, ratio: Float, caption: String, completion: @escaping () -> Void){
        let newPostId = Api.Post.REF_POSTS.childByAutoId().key
        let newPostReference = Api.Post.REF_POSTS.child(newPostId!)
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let currentUserId = currentUser.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        
        let words = caption.components(separatedBy: CharacterSet.whitespacesAndNewlines)

        for var word in words {
            if word.hasPrefix("#") {
                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                let newHashTagRef = Api.HashTag.REF_HASHTAG.child(word.lowercased()).child(newPostId!)
                newHashTagRef.setValue(["timestamp": timestamp])
            }
        }
        
        let dict = ["uid": currentUserId ,"photoUrl": photoUrl, "videoUrl": videoUrl, "caption": caption, "ratio": ratio, "timestamp": timestamp] as [String : Any]
        
        newPostReference.setValue(dict, withCompletionBlock: {
            (error, ref) in
            if error != nil {
                return
            }
            Api.Feed.REF_FEED.child(Auth.auth().currentUser!.uid).child(newPostId!)
                .setValue(["timestamp": timestamp])
            
            let myPostRef = Api.MyPosts.REF_MYPOSTS.child(currentUserId).child(newPostId!)
            myPostRef.setValue(["timestamp": timestamp], withCompletionBlock: { (error, ref) in
                if error != nil {
                    return
                }
            })
            completion()
        })
    }
}
