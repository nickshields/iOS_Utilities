//
//  ViewController.swift
//  AppAuthentication
//
//  Created by Nick Shields on 2020-04-05.
//  Copyright © 2020 Nick Shields. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        
        view.addSubview(appleButton)
        NSLayoutConstraint.activate([
            appleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
    
    @objc
    func didTapAppleButton(){
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let mainVC = segue.destination as? MainViewController, let user =
            sender as? User {
            mainVC.user = user
        }
    }
}

extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
            
        case let credentials as ASAuthorizationAppleIDCredential:
            let user = User(credentials: credentials)
            print(user)
            performSegue(withIdentifier: "segue", sender: user)
            
        default: break
            
        }
        
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Something bad happened", error)
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) ->
        ASPresentationAnchor{
            //Which window are we working with?
            return view.window!
    }
}
