//
//  CameraViewController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/3/18.
//  Copyright © 2018 Harrison Senesac. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    weak var testView: UIView!
    
    override func loadView() {
        super.loadView()
        
        let testView = UIView(frame: .zero)
        testView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(testView)
        
            testView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            testView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            testView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
            // 3
            testView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.65).isActive = true
            
        self.testView = testView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        self.testView.backgroundColor = .red
    }
}
