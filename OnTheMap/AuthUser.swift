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
    var firstName : String?
    var lastName : String?
    
    //returns latitude for user
    var latitude : Double{
        get {
            return selectedLocation?.coordinate.latitude as Double!
        }
    }
    
    //returns longitude for user
    var longitude : Double {
        get {
            return selectedLocation?.coordinate.longitude as Double!
        }
    }
}