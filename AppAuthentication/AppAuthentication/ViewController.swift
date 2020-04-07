//
//  ViewController.swift
//  AppAuthentication
//
//  Created by Nick Shields on 2020-04-05.
//  Copyright © 2020 Nick Shields. All rights reserved.
//

import UIKit
import AuthenticationServices
import FirebaseAuth
import CryptoKit

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
    
    func setStackViewConstraints(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
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
    
    //FIREBASE AUTHENTICATION START
    
    //MARK: 1. Generate Nonce for sign in
    
    private func randomNonceString(length: Int = 32) -> String{
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    private func sha256(_ input: String) -> String{
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    fileprivate var currentNonce: String?
    
    //MARK: Start Apple Sign in Flow: (Do it when they push the button)
    @objc
    func didTapAppleButton(){
        let nonce = randomNonceString()
        currentNonce = nonce
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
    
    
    //FIREBASE AUTHENTICATION FINISH
    

    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let mainVC = segue.destination as? MainViewController, let user =
            sender as? User {
            mainVC.user = user
        }
    }
}

extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
          }
          guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
          }
          // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
          // Sign in with Firebase.
          Auth.auth().signIn(with: credential) { (authResult, error) in
            if (error != nil) {
              // Error. If error.code == .MissingOrInvalidNonce, make sure
              // you're sending the SHA256-hashed nonce as a hex string with
              // your request to Apple.
                print(error!.localizedDescription)
                return
            }
            // User is signed in to Firebase with Apple.
            // ...
            print(authResult!)
          }
        }
        
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
