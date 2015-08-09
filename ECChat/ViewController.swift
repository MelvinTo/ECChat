//
//  ViewController.swift
//  ECChat
//
//  Created by Melvin Tu on 7/29/15.
//  Copyright (c) 2015 Melvin Tu. All rights reserved.
//

import UIKit

import EnClouds
import SwiftTryCatch

let loginUserKey = "selfUser"

class ViewController: UIViewController, EnCloudsLoginDelegate, AVIMClientDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func startButtonClicked(sender: AnyObject) {
        let controller = EnClouds.sharedInstance.newLoginViewController()
        controller.delegate = self
        
        SwiftTryCatch.try({
            // try something
            self.presentViewController(controller, animated: true) { () -> Void in
                
            }
            }, catch: { (error) in
                println("\(error.description)")
            }, finally: {
                // close resources
        })

    }
    
    func success() {
        
        // login successfully
        
        let imClient = AVIMClient.defaultClient()
        if let username = EnClouds.sharedInstance.getUserProfile()?.username {
            imClient.openWithClientId(username, callback: { (succeeded, error) -> Void in
                if error == nil {
                    self.performSegueWithIdentifier("loginSuccess", sender: self)
                } else {
                    NSLog("Failed to login LeanCloud")
                }
            })
        } else {
            NSLog("Failed to login LeanCloud")
        }
    }
}

