//
//  SignInMVPController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 6/13/20.
//  Copyright © 2020 Harrison Senesac. All rights reserved.

import Foundation
import AsyncDisplayKit
import GradientLoadingBar
import NotificationBannerSwift
import FirebaseAuth


class SignInMVPController: ASViewController<ASScrollNode> {
    
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
            
            let child = SignInMVPNode()
            child.signInDelegate = self
            
            stack.spacing = 8
            stack.children = [child]
            
            return stack
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(offsetRepeatPassword), name: Notification.Name("offsetRepeatPasswordNode"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offsetDateOfBirth), name: Notification.Name("offsetDateOfBirthNode"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("offsetRepeatPasswordNode"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("offsetDateOfBirthNode"), object: nil)
    }
    
    @objc func offsetRepeatPassword(){
        //Animate so it looks smoother
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.scrollNode.view.contentOffset = CGPoint(x: 0, y: 100)
        })
        
    }
    
    @objc func offsetDateOfBirth(){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.scrollNode.view.contentOffset = CGPoint(x: 0, y: 100)
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollNode.view.alwaysBounceVertical = true
        self.hideKeyboardWhenTappedAround()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushForgotPassword), name: Notification.Name("forgotPasswordTouched"), object: nil)
        
//        let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveSettings))
//        rightButton.tintColor = .black
//        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    @objc func pushForgotPassword(){
        let alert = UIAlertController(title: "Enter Email Associated with Account", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            //textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
            let textField = alert.textFields![0]
            Auth.auth().sendPasswordReset(withEmail: textField.text ?? "") { (error) in
                if error != nil {
                    //Password reset failed
                    print(error.debugDescription)
                    //ui feedback
                    let failure = NotificationBanner.init(attributedTitle: NSAttributedString(string: "Password Reset Failed, Try Again.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)]), attributedSubtitle: nil, leftView: nil, rightView: nil, style: .danger, colors: nil)
                    failure.show()
                } else {
                    print("Email sent")
                    //ui feedback
                    //Password reset email Succeeded
                    let success = NotificationBanner.init(attributedTitle: NSAttributedString(string: "Password Reset Email Sent", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)]), attributedSubtitle: nil, leftView: nil, rightView: nil, style: .success, colors: nil)
                    success.show()

                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func saveSettings(){
        //Save currentUser
        //Save to database
        //Begin Loading animation
        gradientBar?.fadeIn()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension SignInMVPController: SignInInfoDelegate {
    
    //MARK: Sign User In
    func getSignInInfo(username: String, password: String) {
        Auth.auth().signIn(withEmail: username, password: password) { (result, error) in
            if error == nil {
                currentUserGlobal.id = result?.user.uid
                Api.User.observeCurrentUser { (user) in
                    currentUserGlobal = user
                }
//                let success = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Login Succesful", attributes: [:]), style: .success, colors: nil)
//                success.show()
                isSignedIn = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshFeedCntrlrData"), object: nil)
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
                
            } else {
                let alert = UIAlertController(title: "Error", message: "There was an error signing in. Please Try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
//        AuthService.signIn(email: node.usernameNode.textView.text!, password: node.passwordNode.textView.text!, onSuccess: {
//
//            let success = NotificationBanner.init(attributedTitle: NSAttributedString(string: "Login Successful", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)]), attributedSubtitle: nil, leftView: nil, rightView: nil, style: .success, colors: nil)
//            success.show()
//            self.tabBarController?.selectedIndex = 0
//        }, onError: { error in
//            let alert = UIAlertController(title: "Error", message: "There was an error signing in. Please Try again.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        })
    }
    
    
}
