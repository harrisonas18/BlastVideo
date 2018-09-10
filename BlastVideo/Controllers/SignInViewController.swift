//
//  SignInViewController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 9/8/18.
//  Copyright © 2018 Harrison Senesac. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        self.view.backgroundColor = .white
        
    }
    
    func setUpViews(){
        
        let firstNameField = UITextField()
        firstNameField.translatesAutoresizingMaskIntoConstraints = false
        firstNameField.placeholder = "First Name"
        firstNameField.backgroundColor = .black
        firstNameField.textColor = .white
        
        let lastNameField = UITextField()
        lastNameField.placeholder = "Last Name"
        lastNameField.translatesAutoresizingMaskIntoConstraints = false
        lastNameField.backgroundColor = .black
        lastNameField.textColor = .white
        
        let signInButton = UIButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.titleLabel?.textColor = .white
        signInButton.backgroundColor = .blue
        signInButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [firstNameField, lastNameField, signInButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.backgroundColor = .red
        

        self.view.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }


}
