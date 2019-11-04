//
//  TestViewController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/16/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class TestViewController: UIViewController {
    
    var post: Post = Post()
    var photoURL : URL?
    var videoURL : URL?
    
    @IBOutlet weak var liveView: UIView!
    
    @IBAction func displayTapped(_ sender: Any) {
        
        StorageCacheController.shared.retrieveLivePhoto(post: post) { (livePhoto) in
            let v = PHLivePhotoView(frame: self.liveView.bounds)
            v.contentMode = .scaleAspectFit
            v.livePhoto = livePhoto
            self.liveView.addSubview(v)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        post.photoUrl = "https://firebasestorage.googleapis.com/v0/b/blastvideo-4c71e.appspot.com/o/posts%2F416F5B49-8245-41FE-8C6C-FF5B63475478?alt=media&token=be344fb5-1ffb-44eb-a58b-d4530717faf0"
        post.videoUrl = "https://firebasestorage.googleapis.com/v0/b/blastvideo-4c71e.appspot.com/o/posts%2F6A50888F-C825-4436-BC1A-6132B42B7285?alt=media&token=0d47b8da-6f0a-4297-ae83-51bbbc381b8d"
        post.id = "-LYdrhUbcTUBD6QZNQ0b"
    
    }
    
    
}
