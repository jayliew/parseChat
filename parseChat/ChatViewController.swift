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
    var messages = [String]()
    
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
        let query = PFQuery(className:"Message")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                
                self.messages = []
                
                if let objects = objects {
                    for object in objects {
                        print(object["text"])
                        self.messages.append(object["text"] as! String)
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
        cell.chatLabel.text = messages[indexPath.row]
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
