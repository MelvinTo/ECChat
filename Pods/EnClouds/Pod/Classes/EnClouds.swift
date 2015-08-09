//
//  EnClouds.swift
//  Pods
//
//  Created by Melvin Tu on 7/25/15.
//
//

import Foundation

public class EnClouds {
    public static let sharedInstance = EnClouds()
    
    private init() {
    }
    
    public func newLoginViewController() -> ClassicLoginViewController {
        return ClassicLoginViewController()
    }
}