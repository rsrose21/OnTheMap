//
//  AuthUser.swift
//  OnTheMap
//
//  Created by Ryan Rose on 7/5/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import Foundation
import MapKit

class AuthUser : NSObject {
    
    var sessionId : String?
    var accountId : String?
    var selectedLocation : MKPlacemark?
    var mapString : String?
    var mediaUrl : NSURL?
}