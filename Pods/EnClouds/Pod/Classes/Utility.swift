//
//  Utility.swift
//  Pods
//
//  Created by Melvin Tu on 7/27/15.
//
//

import Foundation

func getLocalizedNibName(nibName: String) -> String {
    let folder = getLocalizationFolder()
    return "\(folder)/\(nibName)"
}

func getLocalizationFolder() -> String {
    let language: AnyObject = NSLocale.preferredLanguages()[0]
    
    // TODO: Need to check if the folder exists... or should switch to default language
    
    return "EnClouds_\(language).bundle"
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
    
    func localizedWithBundle(classInstance: AnyClass) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle(forClass: classInstance), value: "", comment: "")
    }
    
    func localizedWithComment(comment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: comment)
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
    var toDropboxDate: NSDate? {
        var dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        
        // "Wed, 28 Aug 2013 18:12:02 +0000"
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        return dateFormatter.dateFromString(self)
    }
}
