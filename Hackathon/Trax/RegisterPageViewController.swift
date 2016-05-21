//
//  RegisterPageViewController.swift
//  Trax
//
//  Created by 淡蓝色的泪 on 5/9/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userRepeatPassword = repeatPasswordTextField.text
        
        // Check for empty fields
        if (userEmail!.isEmpty || userPassword!.isEmpty || userRepeatPassword!.isEmpty)
        {
            // Display alert message
            
            displayMyAlertMessage("All fields are required")
            
            return
        }
        
        // Check if passwords match
        if userPassword != userRepeatPassword
        {
            // Display an alert message
            displayMyAlertMessage("Passwords do not match")
            return
        }
        
        
        
//        // Store data
//        NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey: "userEmail")
//        NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey: "userPassword")
//        NSUserDefaults.standardUserDefaults().synchronize()
//
//        
//        // Display alert message with confirmation
//        let myAlert = UIAlertController(title: "Alert", message: "Registration is successful. Thank you!", preferredStyle: UIAlertControllerStyle.Alert)
//        
//        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { action in
//            self.dismissViewControllerAnimated(true, completion: nil);
//        }
//        
//        myAlert.addAction(okAction)
//        self.presentViewController(myAlert, animated: true, completion: nil)
        
        
        // Send user data to server side
        let myUrl = NSURL(string: "http://www.shijianloveslareine.com/scripts/userRegister.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        
        let postString = "email=\(userEmail!)&password=\(userPassword!)"
        
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
                    let resultValue = parseJSON["status"] as! String!
                    print("result: \(resultValue)")
                    
                    var isUserRegistered: Bool = false
                    if (resultValue == "Success") {
                        isUserRegistered = true
                    }
                    
                    var messageToDisplay: String = parseJSON["message"] as! String!
                    if (!isUserRegistered)
                    {
                        messageToDisplay = parseJSON["message"] as! String!
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let myAlert = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { action in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        
                        myAlert.addAction(okAction)
                        self.presentViewController(myAlert, animated: true, completion: nil)
                    })
                }
                
            } catch { print(error)}
            
        }
        
        task.resume()
        
    }
    
    
    func displayMyAlertMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
}
