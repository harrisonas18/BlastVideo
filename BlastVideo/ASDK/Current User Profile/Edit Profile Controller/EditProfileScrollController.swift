//
//  EditProfileScrollController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 12/15/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import GradientLoadingBar

class EditProfileScrollController: ASViewController<ASScrollNode> {
    
    let scrollNode : ASScrollNode
    var gradientBar : GradientActivityIndicatorView?
    
    init() {
      
        scrollNode = ASScrollNode()
        scrollNode.backgroundColor = .white
        scrollNode.automaticallyManagesSubnodes = true
        scrollNode.automaticallyManagesContentSize = true
        scrollNode.view.showsVerticalScrollIndicator = false
       
        super.init(node: scrollNode)
        
        scrollNode.layoutSpecBlock = { node, constrainedSize in
            let stack = ASStackLayoutSpec.vertical()
            stack.alignContent = .start
            
            stack.spacing = 8
            stack.children = [EditProfileScrollNode(user: currentUserGlobal)]
            
            return stack
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(offsetEmail), name: Notification.Name("offsetEmailNode"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offsetPhone), name: Notification.Name("offsetPhoneNode"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("offsetEmailNode"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("offsetPhoneNode"), object: nil)
    }
    
    @objc func offsetEmail(){
        //Animate so it looks smoother
        scrollNode.view.contentOffset = CGPoint(x: 0, y: 200)
    }
    
    @objc func offsetPhone(){
        //Animate so it looks smoother of a transition
        scrollNode.view.contentOffset = CGPoint(x: 0, y: 240)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollNode.view.alwaysBounceVertical = true
        title = "Edit Profile"
        self.hideKeyboardWhenTappedAround()
        
        let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveSettings))
        rightButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    var imgData = Data()
    
    @objc func pushImagePicker(){
        ImagePickerManager().pickImage(self) { (image) in
            //Update ui with newly chosen photo
            self.imgData = image.jpegData(compressionQuality: 0.5) ?? Data()
            
        }
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
            
            
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
