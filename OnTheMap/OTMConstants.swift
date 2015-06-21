//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by Ryan Rose on 6/21/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import Foundation

extension OTMClient {
    
    // MARK: - Constants
    struct UdacityConstants {
        
        // MARK: URLs
        static let BaseURL : String = "https://www.udacity.com/api/"
        static let SignUpURL : String = "https://www.udacity.com/account/auth#!/signin"
    }
    
    struct UdacityMethods {
        // MARK: Authentication
        static let AuthenticationSession = "session"
        static let UserID = "users/{id}"
    }
    
}