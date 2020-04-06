//
//  ViewController.swift
//  StackViewing
//
//  Created by Nick Shields on 2020-04-05.
//  Copyright © 2020 Nick Shields. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackView()
        // Do any additional setup after loading the view.
    }
    
    func configureStackView(){
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 20
        setStackViewConstraints()
        addButtonsToStack()
        
    }
    
    func setStackViewConstraints(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
    func addButtonsToStack(){
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(backgroundView)
        print("HI")
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: stackView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])

        
//        backgroundView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
//        backgroundView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
//        backgroundView.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
//        backgroundView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true

    }


}

