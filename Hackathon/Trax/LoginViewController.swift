//
//  LoginViewController.swift
//  Hackathon
//
//  Created by 淡蓝色的泪 on 5/6/16.
//  Copyright © University of Southern California. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        
//        let userEmailStored = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
//        let userPasswordStored = NSUserDefaults.standardUserDefaults().stringForKey("userPassword")
//        
//        if userEmailStored == userEmail
//        {
//            if userPasswordStored == userPassword
//            {
//                // Login is successful
//                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
//                NSUserDefaults.standardUserDefaults().synchronize()
//                self.dismissViewControllerAnimated(true, completion: nil)
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let secondViewController = storyboard.instantiateViewControllerWithIdentifier("SecondVC") as UIViewController
//                presentViewController(secondViewController, animated: true, completion: nil)
//            }
//        }
        
        if (userEmail!.isEmpty || userPassword!.isEmpty) { return }
        
        // Send user data to server side
        let myUrl = NSURL(string: "http://www.shijianloveslareine.com/scripts/userLogin.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        
        let postString = "email=\(userEmail)&password=\(userPassword)"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    var resultValue = parseJSON["status"] as! String!
                    print("result: \(resultValue)")
                    
                    if (resultValue == "Success")
                    {
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        self.dismissViewControllerAnimated(true, completion: nil)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let secondViewController = storyboard.instantiateViewControllerWithIdentifier("SecondVC") as UIViewController
                        self.presentViewController(secondViewController, animated: true, completion: nil)
                    }
                }
                
            } catch { print(error) }
            
        }
        task.resume()
    }
}
