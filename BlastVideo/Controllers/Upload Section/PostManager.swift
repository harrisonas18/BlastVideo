//
//  PostManager.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 12/18/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import Photos

class PostManager: NSObject {
    
    static let shared = PostManager()
    let vidComp = VideoCompressionWrapper()
    
    var livePhoto: PHLivePhoto? 
//        didSet {
//            LivePhoto.extractResources(from: self.livePhoto!) { (resources) in
//                if let sources = resources {
//                    self.photoURL = sources.pairedImage
//                    self.videoURL = sources.pairedVideo
//                } else {
//                    print("Error couldnt fetch Live Photo")
//                }
//            }
//        }
    
    
    var post: Post?
    var videoURL: URL?
    var photoURL: URL?
    
    var newVideoURL: URL?
    var newPhotoURL: URL?
    
    var videoInProgress = false
    var photoInProgress = false
    
    
    func clearPostInfo(){
        post = nil
        videoURL = nil
        photoURL = nil
        newVideoURL = nil
        newPhotoURL = nil
        
    }
    
    func compressVideo() {
        if let url = videoURL{
            videoInProgress = true
            vidComp.exportVideo(videoURL: url, videoHeight: nil, videoWidth: nil) { (compressedVideoURL) in
                self.videoInProgress = false
                if let newURL = compressedVideoURL {
                    self.newVideoURL = newURL
                } else {
                    print("No URL returned")
                }
            }
        } else {
            print("No video URL")
        }
        
    }
    
    func compressPhoto() {
        if let url = photoURL {
            self.photoInProgress = true
            
        } else {
            print("No photo URL")
        }
        
    }
    
    
    
}
