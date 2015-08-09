//
//  UserListViewController.swift
//  EnClouds
//
//  Created by Melvin Tu on 7/27/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import Foundation

class UserListViewController : UITableViewController, UITableViewDataSource, UITableViewDelegate {
    let userList = ["melvinto", "changche"]
    let myUserID = "tbb"
    
    let userCellIdentifier = "userCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        

    }
    
    // MARK: Get available users
    
    
    // MARK: tableView delegates
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(userCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = userList[row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let selectedUser = userList[row]
        NSLog("selected user: \(selectedUser)")
        
//        AVIMClient.defaultClient().createConversationWithName("\(self.myUserID)-\(selectedUser)", clientIds: [selectedUser], attributes: [:], options: 0, callback: { (conversation, createError) -> Void in
//            if createError == nil {
//                self.performSegueWithIdentifier("toChat", sender: conversation)
//            } else {
//                NSLog("Failed to create new conversation")
//            }
//        })
        
        
        let query = AVIMClient.defaultClient().conversationQuery()
        query.orderByDescending("createdAt")
        query.whereKey(kAVIMKeyMember, sizeEqualTo: 2)
        query.whereKey(kAVIMKeyMember, containsAllObjectsInArray:[myUserID, selectedUser])
        
        query.findConversationsWithCallback { (objects, error) -> Void in
            if error != nil {
                NSLog("Meet error when query conversations: \(error)")
            } else if objects == nil || objects.count < 1 {
                AVIMClient.defaultClient().createConversationWithName("\(self.myUserID)-\(selectedUser)", clientIds: [selectedUser], attributes: [:], options: 0, callback: { (conversation, createError) -> Void in
                    if createError == nil {
                        self.performSegueWithIdentifier("toChat", sender: conversation)
                    } else {
                        NSLog("Failed to create new conversation")
                    }
                })
            } else {
                if let conversation = objects.first as? AVIMConversation {
                    self.performSegueWithIdentifier("toChat", sender: conversation)
                }
            }
        }
        
    }

    // MARK: tableView delegates
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? MessageViewController {
            if let conversation = sender as? AVIMConversation {
                destinationVC.conversation = conversation
            }
        }
    }
}