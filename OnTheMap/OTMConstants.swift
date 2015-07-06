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
    
    struct ParseConstants {
        
        // MARK: API Key
        static let AppID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let BaseURL : String = "https://api.parse.com/1/classes/"

    }
    
    struct ParseMethods {
        // MARK: Authentication
        static let StudentLocation = "StudentLocation"

    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
    }
}