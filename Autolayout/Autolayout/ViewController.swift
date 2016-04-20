//
//  ViewController.swift
//  Autolayout
//
//  Created by 淡蓝色的泪 on 4/19/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var loginField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    var secure: Bool = false { didSet {updateUI() } }
    
    private func updateUI()
    {
        passwordField.secureTextEntry = secure
        passwordLabel.text = secure ? "Secured Password" : "Password"
    }
    
    @IBAction func toggleSecurity() {
        secure = !secure
    }
}

