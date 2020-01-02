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
    func uploadPost(photoURL: URL, videoURL: URL, ratio: Float, caption: String, completion: @escaping (Bool) -> Void){
        
        var photoString : String = ""
        var videoString : String = ""
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "dispatchQueue", qos: .userInitiated)
        
        let uniformTypeID = NSUUID().uuidString
        
        group.enter()
        print("photo upload called")
        uploadPhoto(id: uniformTypeID, photoURL: photoURL, completion: { (photoURLString) in
            if let pString = photoURLString {
                print("photo uploaded")
                photoString = pString
                group.leave()
            }
        })
        
        group.enter()
        print("video upload called")
        uploadVideo(id: uniformTypeID, videoURL: videoURL, completion: { (videoURLString) in
            if let vString = videoURLString {
                print("video uploaded")
                videoString = vString
                group.leave()
            }
        })
        
        group.notify(queue: queue) {
            print("post upload called")
            self.uploadPostData(photoUrl: photoString, videoUrl: videoString, ratio: ratio , caption: caption, uniformTypeID: uniformTypeID, completion: { success in
                print("post uploaded")
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
                
            })
        }
    }
    
    //Upload Video
    func uploadVideo(id: String, videoURL: URL, completion: @escaping (_ videoURL: String?) -> Void){
        let photoRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(id).child("photo")
        //let videoIdString = NSUUID().uuidString
        //let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(videoIdString)
        photoRef.putFile(from: videoURL, metadata: nil) { (metadata, error) in
            if error != nil {
                //ProgressHUD.showError(error!.localizedDescription)
                print(error!.localizedDescription)
                completion(nil)
            }
            var videoURLString: String = ""
            photoRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    print("Error could not retrieve Video URL")
                    completion(nil)
                    return
                }
                videoURLString = downloadURL.absoluteString
                completion(videoURLString)
            }
        }
    }
    
    //Upload Photo
    private func uploadPhoto(id: String, photoURL: URL, completion: @escaping (_ photoURL: String?) -> Void){
        //let photoIdString = NSUUID().uuidString
        //let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(photoIdString)
        let videoRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(id).child("video")
        videoRef.putFile(from: photoURL, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            var photoURLString: String = ""
            videoRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    print("Error could not retrieve Photo URL")
                    completion(nil)
                    return
                }
                photoURLString = downloadURL.absoluteString
                completion(photoURLString)
            }
        }
    }
    
    //Upload Post Data to database
    private func uploadPostData(photoUrl: String, videoUrl: String, ratio: Float, caption: String, uniformTypeID: String, completion: @escaping (Bool) -> Void){
        let newPostId = Api.Post.REF_POSTS.childByAutoId().key
        let newPostReference = Api.Post.REF_POSTS.child("posts").child(newPostId!)
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let currentUserId = currentUser.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        
        let words = caption.components(separatedBy: CharacterSet.whitespacesAndNewlines)

        for var word in words {
            if word.hasPrefix("#") {
                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                let newHashTagRef = Api.HashTag.REF_HASHTAG.child(word.lowercased()).child("posts").child(newPostId!)
                newHashTagRef.setValue(["timestamp": timestamp])
            }
        }
        
        let dict = ["uid": currentUserId ,"photoUrl": photoUrl, "videoUrl": videoUrl, "caption": caption, "ratio": ratio, "timestamp": timestamp, "uniformTypeID": uniformTypeID] as [String : Any]
        
        newPostReference.setValue(dict, withCompletionBlock: {
            (error, ref) in
            if error != nil {
                completion(false)
            }
            Api.Feed.REF_FEED.child(Auth.auth().currentUser!.uid).child("posts").child(newPostId!)
                .setValue(["timestamp": timestamp])
            
            let myPostRef = Api.MyPosts.REF_MYPOSTS.child(currentUserId).child("posts").child(newPostId!)
            myPostRef.setValue(["timestamp": timestamp], withCompletionBlock: { (error, ref) in
                if error != nil {
                    completion(false)
                }
            })
            completion(true)
        })
    }
}
