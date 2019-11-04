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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SignInDisplayController: SignInInfoDelegate {
    func getSignInInfo(username: String, password: String) {
        Auth.auth().signIn(withEmail: username, password: password) { (result, error) in
            if error == nil {
                currentUserGlobal.id = result?.user.uid
                Api.User.observeCurrentUser { (user) in
                    currentUserGlobal = user
                }
                let success = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Login Succesful", attributes: [:]), style: .success, colors: nil)
                success.show()
                
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
