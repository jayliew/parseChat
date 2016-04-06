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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    // MARK: Actions
    
    @IBAction func onSignUp(sender: AnyObject) {
        let user = PFUser()
        
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
                // Hooray! Let them use the app now.
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

