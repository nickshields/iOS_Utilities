//
//  MainViewController.swift
//  AppAuthentication
//
//  Created by Nick Shields on 2020-04-05.
//  Copyright © 2020 Nick Shields. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var user: User?
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsLabel.text = user?.debugDescription ?? "" 
    }
    
    
}
