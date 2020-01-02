//
//  EditProfileViewController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 5/21/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import GradientLoadingBar
import NotificationBannerSwift

class EditProfileViewController: ASViewController<EditProfileNode> {
    
    var user: UserObject?
    var gradientBar : GradientActivityIndicatorView?
    
    init() {
        super.init(node: EditProfileNode(user: currentUserGlobal))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientBar = GradientActivityIndicatorView(frame: CGRect(x: 0, y: navigationController?.navigationBar.bounds.maxY ?? 0, width: UIScreen.screenWidth(), height: 3))
        gradientBar?.fadeOut()
        navigationController?.navigationBar.addSubview(gradientBar!)
        self.node.editProfileDelegate = self
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Edit Profile", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.medium)])
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        NotificationCenter.default.addObserver(self, selector: #selector(pushImagePicker), name: Notification.Name("PushImagePicker"), object: nil)
        
        let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveSettings))
        rightButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButton
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func saveSettings(){
        //Save currentUser
        //Save to database
        //Begin Loading animation
        gradientBar?.fadeIn()
        Api.Helper.uploadImageToFirebaseStorage(data: self.imgData) { (url) in
            var imgURL: String?
            if url == "" {
               imgURL = nil
            }
            Api.Auth.updateProfile(profileImgURL: imgURL, username: nil , email: nil, realName: self.node.nameNode.textView.text, bio: self.node.bioNode.textView.text, FCMToken: nil, onSuccess: {
                //Stop loading animation
                DispatchQueue.main.async {
                    self.gradientBar?.fadeOut()
                    let success = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Save Succesful", attributes: [:]), style: .success, colors: nil)
                    success.show()
                    print("Successfully saved profile")
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.gradientBar?.fadeOut()
                    let success = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Could Not Save", attributes: [:]), style: .danger, colors: nil)
                    success.show()
                    print("Couldn't save profile")
                }
            }
            
        }
        
        
    }
    
    var imgData = Data()
    
    @objc func pushImagePicker(){
        ImagePickerManager().pickImage(self) { (image) in
            self.node.profImage.isHidden = true
            self.node.profImageBack.image = image
            self.imgData = image.jpegData(compressionQuality: 0.5) ?? Data()
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //TODO: Load Saved Profile Data
    //Save Changed Data
    
    
}

extension EditProfileViewController: EditProfileDelegate {
    func updateProfileInfo(image: UIImage, name: String, bio: String) {
        
    }
    
}
