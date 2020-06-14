//
//  SignUpPopoverController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/11/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import UIKit

class SignUpPopoverController: UIViewController {
    
    @IBOutlet var mainView: UIView!

    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var googleView: UIView!
    
    @IBOutlet weak var popupView: UIView!
    
    @IBAction func signInButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        //Write locations of view controllers that are subbed to these values
        //DiscoverPageController - "PushSignInVC"
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabToZero"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushSignInVC"), object: nil)
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUpButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //Write locations of view controllers that are subbed to these values
        //DiscoverPageController - "PushSignUpVC"
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabToZero"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushSignUpVC"), object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar.isHidden = true
        
        facebookView.layer.cornerRadius = 5.0
        facebookView.clipsToBounds = true
        facebookView.layer.borderWidth = 1.0
        facebookView.layer.borderColor = UIColor.lightGray.cgColor
        
        googleView.layer.cornerRadius = 5.0
        googleView.clipsToBounds = true
        googleView.layer.borderWidth = 1.0
        googleView.layer.borderColor = UIColor.lightGray.cgColor
        
        mainView.backgroundColor = .clear
        
        signUpButton.layer.cornerRadius = 5.0
        signUpButton.clipsToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        //location is relative to the current view
        // do something with the touched point
        if touch?.view != self.popupView {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
