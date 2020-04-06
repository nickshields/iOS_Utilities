//
//  ViewController.swift
//  AppAuthentication
//
//  Created by Nick Shields on 2020-04-05.
//  Copyright © 2020 Nick Shields. All rights reserved.
//

import UIKit
import AuthenticationServices

@IBDesignable class ViewController: UIViewController {
    
    var stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackView()
    }
    
    func configureStackView(){
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        setStackViewConstraints()
        addButtonsToStackView()
    }
    
    func addButtonsToStackView(){
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login_image")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(imageView)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "lets login to this bitch"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)
        
        let loginLabel = UILabel()
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.text = "Login:"
        stackView.addArrangedSubview(loginLabel)
        
        let username = UITextField()
        username.placeholder = "Enter username."
        username.translatesAutoresizingMaskIntoConstraints = false
        username.setBottomBorder()
        stackView.addArrangedSubview(username)
        
        let password = UITextField()
        password.placeholder = "Enter password."
        password.translatesAutoresizingMaskIntoConstraints = false
        password.setBottomBorder()
        stackView.addArrangedSubview(password)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        let loginButton = UIButton()
        loginButton.setTitle("Sign the fuck in", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        loginButton.backgroundColor = .black
        loginButton.layer.cornerRadius = 10
        stackView.addArrangedSubview(loginButton)
        
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        appleButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        stackView.addArrangedSubview(appleButton)
        
    }
    
    func setStackViewConstraints(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
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
            //This is for the login popup.
            return view.window!
    }
}

extension UITextField {
  func setBottomBorder() {
    self.borderStyle = .none
    self.layer.backgroundColor = UIColor.white.cgColor

    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.gray.cgColor
    self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.layer.shadowOpacity = 1.0
    self.layer.shadowRadius = 0.0
  }
}
