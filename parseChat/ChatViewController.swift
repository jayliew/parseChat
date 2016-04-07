//
//  ChatViewController.swift
//  parseChat
//
//  Created by Jay Liew on 4/6/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: Actions
    
    @IBAction func onCompose(sender: AnyObject) {
        let message = PFObject(className:"Message")
        message["text"] = inputTextField.text
        message.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("saved: " + (message["text"] as! String))
            } else {
                print("NOT saved: " + (message["text"] as! String) + " " + error!.description)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
