//
//  ProfileNotSignedInController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/24/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit

class ProfileNotSignedInController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(pushSignInVC), name: Notification.Name("PushSignInVC"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(pushSignUpVC), name: Notification.Name("PushSignUpVC"), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PushSignInVC"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PushSignUpVC"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
    }
    
    @objc func pushSignInVC(){
        print("Push vc called")
        //self.dismiss(animated: true, completion: nil)
        let vc = SignInDisplayController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pushSignUpVC(){
        print("Push vc called")
        //self.dismiss(animated: true, completion: nil)
        let vc = SignUpDisplayController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
