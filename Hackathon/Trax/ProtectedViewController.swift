//
//  ProtectedViewController.swift
//  Trax
//
//  Created by 淡蓝色的泪 on 5/8/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class ProtectedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewControllerWithIdentifier("SecondVC") as UIViewController
        presentViewController(secondViewController, animated: true, completion: nil)
        if !isUserLoggedIn
        {
            self.performSegueWithIdentifier("loginView", sender: self)
        }
    }
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.performSegueWithIdentifier("loginView", sender: self)
    }
}
