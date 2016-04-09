//
//  ViewController.swift
//  parseChat
//
//  Created by Jay Liew on 4/5/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    // MARK: Properties
    
    var currentUser: PFUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if currentUser != nil {
            let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ChatScreen") as UIViewController
            presentViewController(VC, animated: true){}
        }
        
    } // viewDidLoad
    
    // MARK: Actions
    
    @IBAction func onLogin(sender: AnyObject) {

        if !checkRequiredFields() {
            return
        }

        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("LOGGED IN!")
                self.currentUser = PFUser.currentUser()
                // Do stuff after successful login.
            } else {
                print("FAIL LOGIN")
                // The login failed. Check error to see why.
            }
        }
    }
    
    private func checkRequiredFields() -> Bool {
        // make username and pass mandatory field
        if usernameField.text == "" {
            let alertController = UIAlertController(title: "Missing", message: "Please Enter Username", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                // handle cancel response here. Doing nothing will dismiss the view.
            }
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true) {
                // optional code for what happens after the alert controller has finished presenting
            }
            return false
        }

        if passwordField.text == "" {
            let alertController = UIAlertController(title: "Missing", message: "Please Enter Password", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                // handle cancel response here. Doing nothing will dismiss the view.
            }
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true) {
                // optional code for what happens after the alert controller has finished presenting
            }
            return false
        }

        return true
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        let user = PFUser()
        
        if !checkRequiredFields() {
            return
        }
        
        user.username = usernameField.text
        user.password = passwordField.text
        user.email = emailField.text
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? String
                print("ERROR: " + errorString!)
                // Show the errorString somewhere and let the user try again.
            } else {
                print("REGISTRATION SUCCEEDED")
                self.currentUser = PFUser.currentUser()
                // Hooray! Let them use the app now.
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

