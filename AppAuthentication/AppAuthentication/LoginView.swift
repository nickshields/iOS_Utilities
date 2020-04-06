//
//  LoginView.swift
//  AppAuthentication
//
//  Created by Nick Shields on 2020-04-05.
//  Copyright © 2020 Nick Shields. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginView: UIStackView {

    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("INITIALIZNG FRAME")
        setStackViewConstraints()
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        print("INITIALIZNG CODER")
        setStackViewConstraints()
        setupButtons()
    }
    
    func setStackViewConstraints(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.leadingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        self.trailingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
    }
    
    private func setupButtons(){
        let appleButton = ASAuthorizationAppleIDButton()
        
        //Add constraints
        appleButton.translatesAutoresizingMaskIntoConstraints = false //Disables automatically generated constraints
        appleButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        appleButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        //self.translatesAutoresizingMaskIntoConstraints = false
        //The height and width anchors allow me to define the object.
        

        //self.distribution = .fillEqually
        //This add the button to the stack at the end:
        addArrangedSubview(appleButton)
        
        

        //appleButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //appleButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        //appleButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
//        appleButton.translatesAutoresizingMaskIntoConstraints = false
//        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
//
//        view.addSubview(appleButton)
//        NSLayoutConstraint.activate([
//            appleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
//            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
//        ])

    }
    
    

}
