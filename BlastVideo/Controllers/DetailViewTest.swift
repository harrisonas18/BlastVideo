//
//  DetailViewTest.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 2/18/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import PhotosUI
import AVKit
import ImageIO

class DetailViewTest: UIViewController {
    
    typealias LivePhotoResources = (pairedImage: URL, pairedVideo: URL)
    
    @IBOutlet var livePhotoView : UIView!
    var looper : AVPlayerLooper!
    var selectedImage: UIImage?
    var videoURL: URL?
    var photoURL: URL?
    var atIndexPath: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    func loadLivePhoto(livePhoto: PHLivePhoto) -> Void {
        photoURL = URL(string: posts[atIndexPath!].photoUrl!)
        videoURL = URL(string: posts[atIndexPath!].videoUrl!)
        
        
    }
    
    
    
}
