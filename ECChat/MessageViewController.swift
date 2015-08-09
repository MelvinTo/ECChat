//
//  MessageViewController.swift
//  EnClouds
//
//  Created by Melvin Tu on 7/27/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import Foundation

class MessageViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, AVIMClientDelegate   {
    
    var testMessages: NSMutableArray = []
    let messageCellIdentifier = "messageCell"
    
    var conversation : AVIMConversation? = nil
    var theRefreshControl : UIRefreshControl? = nil
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
    @IBOutlet weak var dockViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        NSLog("view did load is called")

        initTableViews()
        
        AVIMClient.defaultClient().delegate = self
        
        loadMessagesWhenInit()
        
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tableViewTapped")
        self.tableView.addGestureRecognizer(tapGesture)
        
        // Register notifications on keyboard activities
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appBecomeActive:", name:UIApplicationDidBecomeActiveNotification, object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        NSLog("view did appear is called")
    }
    
    func initTableViews() {
        self.tableView.addSubview(self.refreshControl())
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    func scrollToLast() {
        if (self.testMessages.count > 0) {
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.testMessages.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: false)
        }
    }

    func refreshControl() -> UIRefreshControl {
        if let r = theRefreshControl {
            return r
        } else {
            theRefreshControl = UIRefreshControl()
            theRefreshControl?.addTarget(self, action: "loadOldMessages:", forControlEvents: .ValueChanged)
            return theRefreshControl!
        }
    }
    
    func filterMessages(messages: NSArray) -> Array<AVIMTypedMessage> {
        var array = NSMutableArray()
        for message in messages {
            if let m = message as? AVIMTypedMessage {
                array.addObject(message)
            }
        }
        return array as NSArray as! [AVIMTypedMessage]
    }
    
    func loadMessagesWhenInit() {
        self.conversation?.queryMessagesWithLimit(15, callback: { (messages, error) -> Void in
            if error == nil {
                self.testMessages = NSMutableArray()
                self.testMessages.addObjectsFromArray(self.filterMessages(messages))
                self.tableView.reloadData()
                self.scrollToLast()
            } else {
                NSLog("Meet error when quering existing messages: \(error)")
            }
        })
    }
    
    func loadOldMessages(refreshControl: UIRefreshControl) {
        if self.testMessages.count == 0 {
            refreshControl.endRefreshing()
            return
        } else {
            let curFirstMessage = self.testMessages[0] as! AVIMTypedMessage
            
            self.conversation?.queryMessagesBeforeId(nil, timestamp: curFirstMessage.sendTimestamp, limit: 15, callback: { (messages, error) -> Void in
                refreshControl.endRefreshing()
                let typedMessages = self.filterMessages(messages)
                let count = typedMessages.count
                if count == 0 {
                    NSLog("No more old messages")
                } else {
                    var messageArray : NSMutableArray = NSMutableArray(array: typedMessages)
                    messageArray.addObjectsFromArray(self.testMessages as [AnyObject])
                    self.tableView.reloadData()
                    
                    if self.testMessages.count > count {
                        let indexPath = NSIndexPath(forRow: count, inSection: 0)
                        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false    )
                    }
                }
            })
        }
    }
    
    // MARK: Callbacks
    
    func tableViewTapped() {
        self.messageField.endEditing(true)
    }
    
    @IBAction func sendClicked(sender: AnyObject) {
        self.messageField.endEditing(true)
        if let text = messageField.text {
            self.sendText(text)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let frameHeight = keyboardFrame.CGRectValue().size.height
        
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        self.keyboardHeight.constant = frameHeight
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.scrollToLast()
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        self.keyboardHeight.constant = 0
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func appBecomeActive(notification: NSNotification) {
        self.loadMessagesWhenInit()
    }
    
    // MARK: Callbacks


    
    // MARK: TableView Delegate Methods

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(messageCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        let message = testMessages[row] as! AVIMTypedMessage
        cell.textLabel?.text = message.text
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testMessages.count
    }
    
    // MARK: TableView Delegate Methods

    
    // MARK: AVOSCloud Interaction
    func sendText(text: String) {
        let message = AVIMTextMessage(text: text, attributes: nil)
        self.conversation?.sendMessage(message, callback: { (success, error) -> Void in
            if error == nil {
                self.testMessages.addObject(message)
                self.tableView.reloadData()
                self.scrollToLast()
                self.messageField.text = nil
            } else {
                NSLog("Meet error when sending message: \(error)")
            }
        })
    }
    
    
    func conversation(conversation: AVIMConversation!, didReceiveTypedMessage message: AVIMTypedMessage!) {
        if conversation.conversationId == self.conversation?.conversationId {
            self.testMessages.addObject(message)
            self.tableView.reloadData()
            self.scrollToLast()
        }
    }
    // MARK: AVOSCloud Interaction

    
    
}