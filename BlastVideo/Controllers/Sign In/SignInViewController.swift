//
//  SignInViewController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/8/18.
//  Copyright © 2018 Harrison Senesac. All rights reserved.
//

import UIKit
import FirebaseAuth
class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleTextField()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if user != nil {
                let tabBarController = TabBarController()
                self.present(tabBarController, animated: true, completion: nil)
            } else {
                let tabBarController = TabBarController()
                self.present(tabBarController, animated: true, completion: nil)
            }
            
            
        }
        
    }
    

    func handleTextField() {
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                signInButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
                signInButton.isEnabled = false
                return
        }
        
        signInButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        signInButton.isEnabled = true
    }
    
    @IBAction func signInButton_TouchUpInside(_ sender: Any) {
        view.endEditing(true)
        
        Api.Auth.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            let tabBarController = TabBarController()
            self.present(tabBarController, animated: true, completion: nil)
        }) { (error) in
            let alert = UIAlertController(title: "Error", message: "There was an error signing in. Please Try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}

