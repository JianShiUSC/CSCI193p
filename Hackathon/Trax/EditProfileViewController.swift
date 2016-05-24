//
//  EditProfileViewController.swift
//  Trax
//
//  Created by 淡蓝色的泪 on 5/18/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordRepeatTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myUrl = NSURL(string: "http://www.shijianloveslareine.com/scripts/showUserName.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        
        let postString = ""
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
        {
            data, response, error in

            if error != nil {
                print("error=\(error)")
                return
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                if let parseJSON = json
                {
                    let fn = parseJSON["firstName"] as! String!
                    let ln = parseJSON["lastName"] as! String!
                    self.firstNameTextField.text = fn
                    self.lastNameTextField.text = ln
                }

            } catch { print(error) }
        }
        task.resume()
        
//        firstNameTextField.text = "Jian"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func chooseProfileButtonTapped(sender: AnyObject) {
    }

    @IBAction func saveButtonTapped(sender: AnyObject) {
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let password = passwordTextField.text
        let repeatPassword = passwordRepeatTextField.text
        
        // Check for empty fields
        if (firstName!.isEmpty || lastName!.isEmpty || password!.isEmpty || repeatPassword!.isEmpty)
        {
            // Display an alert message
            displayMyAlertMessage("All fields are required")
            return
        }
        
        // Check if passwords match
        if password != repeatPassword
        {
            // Display an alert message
            displayMyAlertMessage("Passwords do not match")
            return
        }
        
        let myUrl = NSURL(string: "http://www.shijianloveslareine.com/scripts/updateProfile.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        
        let postString = "firstName=\(firstName!)&lastName=\(lastName!)"
        
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
                    
                    let messageToDisplay: String = parseJSON["message"] as! String!

                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let myAlert = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { action in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        
                        myAlert.addAction(okAction)
                        self.presentViewController(myAlert, animated: true, completion: nil)
                    })
                }
                
            } catch { print(error) }
            
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
