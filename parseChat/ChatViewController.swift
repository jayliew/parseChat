//
//  ChatViewController.swift
//  parseChat
//
//  Created by Jay Liew on 4/6/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    var messages = [[String: String?]]()
    
    // MARK: Outlets
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.dataSource = self
        chatTableView.estimatedRowHeight = 100
        chatTableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "loadMessages", userInfo: nil, repeats: true)
        
        loadMessages()
    }

    func loadMessages(){
        let query = PFQuery(className:"Message").orderByDescending("createdAt").includeKey("user")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                
                self.messages = [[String: String?]]()
                
                if let objects = objects {
                    for object in objects {
                        
                        var tempDict = [String: String?]()
                        
                        if object["user"] != nil {
                            let pfu = object["user"] as! PFUser
                            tempDict = ["username": pfu.username!]
                        }else{
                            tempDict["username"] = nil
                        }
                        
                        tempDict["text"] = object["text"] as? String
                        
                        self.messages.append(tempDict)
                    }
                }
                self.chatTableView.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func onCompose(sender: AnyObject) {
        let message = PFObject(className:"Message")
        message["text"] = inputTextField.text
        message["user"] = PFUser.currentUser()
        message.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("saved: " + (message["text"] as! String))
            } else {
                print("NOT saved: " + (message["text"] as! String) + " " + error!.description)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chatCell") as! ChatCell
        var message = messages[indexPath.row]
        cell.chatLabel.text = message["text"]!
        if message["username"] != nil {
            cell.usernameLabel.hidden = false
            cell.usernameLabel.text = message["username"]!
            cell.usernameLabel.sizeToFit()
        }else{
            cell.usernameLabel.hidden = true
        }
        return cell
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
