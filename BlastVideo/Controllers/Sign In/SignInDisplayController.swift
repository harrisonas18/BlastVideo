//
//  Sign.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/25/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import NotificationBannerSwift
import FirebaseAuth

class SignInDisplayController: ASViewController<SignInNode> {
    
    
    init() {
        super.init(node: SignInNode())
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.node.signInDelegate = self
        
        //Add notification listener to listen to when the forgot password label is pressed then present
        NotificationCenter.default.addObserver(self, selector: #selector(pushForgotPassword), name: Notification.Name("forgotPasswordTouched"), object: nil)
    }
    
    //MARK: Recover Password
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SignInDisplayController: SignInInfoDelegate {
    
    //MARK: Sign User In
    func getSignInInfo(username: String, password: String) {
        Auth.auth().signIn(withEmail: username, password: password) { (result, error) in
            if error == nil {
                currentUserGlobal.id = result?.user.uid
                Api.User.observeCurrentUser { (user) in
                    currentUserGlobal = user
                }
                let success = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Login Succesful", attributes: [:]), style: .success, colors: nil)
                success.show()
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
