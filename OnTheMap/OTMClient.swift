//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Ryan Rose on 6/21/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import Foundation

class OTMClient : NSObject {
    
    /* Shared session */
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> OTMClient {
        
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        
        return Singleton.sharedInstance
    }
}