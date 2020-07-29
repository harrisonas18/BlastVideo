//
//  EditPhotoViewController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/7/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import MobileCoreServices
import AsyncDisplayKit
import GradientLoadingBar
import NotificationBannerSwift
import NextLevelSessionExporter
import VideoToolbox

class EditPhotoViewController: ASViewController<EditPhotoNode> {
    
    // MARK: - Variables
    let livePhoto: PHLivePhoto
    var selectedImage: UIImage?
    var videoURL: URL?
    var photoURL: URL?
    var editPhotoDelegate: EditPhotoDelegate?
    var captionText: String? = nil
    
    var queue = DispatchQueue(label: "com.liveme.editPhotoQueue.serial")
    
    init(livePhoto: PHLivePhoto, displayPhoto: PHLivePhoto, tmpVideo: URL, tmpPhoto: URL) {
        self.livePhoto = livePhoto
        self.videoURL = tmpVideo
        self.photoURL = tmpPhoto
        super.init(node: EditPhotoNode(livePhoto: displayPhoto))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        self.hideKeyboardWhenTappedAround()
        self.node.delegate = self

    }
    
}

extension EditPhotoViewController {
    
    func setupNavBar() {
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Post", attributes:[
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24.0),
            NSAttributedString.Key.foregroundColor: UIColor.black])
        
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
        let rightBarButtonItem = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(uploadPressed))
        rightBarButtonItem.tintColor = UIColor.textColor()
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    //Bugs: Resizing doesn't account for landscape mode
    @objc func uploadPressed() {
        view.endEditing(true)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        DispatchQueue.main.async {
            GradientLoadingBar.shared.fadeIn()
        }
        Api.Upload.uploadPost(photoURL: PostManager.shared.photoURL ?? URL(string: "")!, videoURL: PostManager.shared.videoURL ?? URL(string: "")!, ratio: 0.75, caption: self.captionText ?? "") { success in
            if success {
                DispatchQueue.main.async {
                    GradientLoadingBar.shared.fadeOut()
//                    let success = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Upload Succesful", attributes: [:]), style: .success, colors: nil)
//                    success.show()
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeIndex"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scrollToTopDiscover"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshDiscover"), object: nil)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    GradientLoadingBar.shared.fadeOut()
//                    let failure = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Upload Failed", attributes: [:]), style: .danger, colors: nil)
//                    failure.show()
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
             
        }

    }
    
    
}

extension EditPhotoViewController: EditPhotoDelegate {
    func getCaptionText(text: String) {
        captionText = text
    }
}
