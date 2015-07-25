//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by Ryan Rose on 7/5/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import UIKit
import Foundation

// MARK: - Convenient Resource Methods

extension OTMClient {
    
    // MARK: - Authentication (GET) Methods
    /*
    Steps for Authentication...
    https://docs.google.com/document/d/1MECZgeASBDYrbBg7RlRu9zBBLGd3_kfzsN-0FtURqn0/pub?embedded=true
    */
    func authenticateWithViewController(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let method : String = UdacityConstants.BaseURL + UdacityMethods.AuthenticationSession
        let request = NSMutableURLRequest(URL: NSURL(string: method)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)

        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if let error = downloadError {
                let newError = OTMClient.errorForData(data, response: response, error: error)
                completionHandler(success: false, errorString: "Login Error")
            } else {
                //FOR ALL RESPONSES FROM THE UDACITY API, YOU WILL NEED TO SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE.
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                
                let jsonDict = NSJSONSerialization.JSONObjectWithData(newData, options: nil, error: nil)! as! NSDictionary
                
                //Check status for error
                if let status = jsonDict["status"] as? Double {
                    //return error to callback
                    completionHandler(success: false, errorString: "Invalid Login")
                }
                
                //Check if login was successfull
                if let account = jsonDict["account"] as? NSDictionary {
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.loggedUser.accountId = account["key"] as? String
                    
                    if let session = jsonDict["session"] as? NSDictionary{
                        appDelegate.loggedUser.sessionId = session["id"] as? String
                        completionHandler(success: true, errorString: nil)
                    }
                }
            }
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    // Mark: - Logout user from Udacity API
    
    func logoutUser(completionHandler: (success: Bool, errorString: String?) -> Void) {
        let method : String = UdacityConstants.BaseURL + UdacityMethods.AuthenticationSession
        let request = NSMutableURLRequest(URL: NSURL(string: method)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if let error = downloadError {
                let newError = OTMClient.errorForData(data, response: response, error: error)
                completionHandler(success: false, errorString: "Login Error")
            } else {
                //FOR ALL RESPONSES FROM THE UDACITY API, YOU WILL NEED TO SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE.
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                
                let jsonDict = NSJSONSerialization.JSONObjectWithData(newData, options: nil, error: nil)! as! NSDictionary
                
                //Check status for error
                if let status = jsonDict["status"] as? Double {
                    //return error to callback
                    completionHandler(success: false, errorString: "Unable to Logout")
                }
                
                //Check if logout was successfull
                if let session = jsonDict["session"] as? NSDictionary{
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.loggedUser.sessionId = nil
                    completionHandler(success: true, errorString: nil)
                }
            }
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    // MARK: - GET Convenience Methods
    
    func getStudentLocations(refresh: Bool, completionHandler: (result: [StudentInformation]?, error: NSError?) -> Void) {
  
        //first check the cache unless a refresh was forced
        if (refresh == false && self.students.count > 0) {
            completionHandler(result: students, error: nil)
        } else {
            /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
            var parameters = [String: AnyObject]()
            parameters["count"] = "1"
            // sort by create timestamp descending
            parameters["order"] = "-createdAt"
            
            let url : String = ParseConstants.BaseURL + ParseMethods.StudentLocation
            
            /* 2. Make the request */
            taskForGETMethod(url, parameters: parameters) { JSONResult, error in
                
                /* 3. Send the desired value(s) to completion handler */
                if let error = error {
                    completionHandler(result: nil, error: error)
                } else {
                    
                    if let results = JSONResult.valueForKey("results") as? [[String : AnyObject]] {
                        //convert json results to a dictionary of StudentInformation objects
                        self.students = StudentInformation.studentsFromResults(results)
                        completionHandler(result: self.students, error: nil)
                    } else {
                        completionHandler(result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                    }
                }
            }
        }
    }
    
    func getAccountDetails(accountId: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        var mutableMethod : String = UdacityConstants.BaseURL
        mutableMethod += "users/" + accountId as String!
        let request = NSMutableURLRequest(URL: NSURL(string: mutableMethod)!)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if let error = downloadError {
                let newError = OTMClient.errorForData(data, response: response, error: error)
                completionHandler(success: false, errorString: "Get Account Details Error")
            } else {
                //FOR ALL RESPONSES FROM THE UDACITY API, YOU WILL NEED TO SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE.
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                
                let jsonDict = NSJSONSerialization.JSONObjectWithData(newData, options: nil, error: nil)! as! NSDictionary
                
                //Check status for error
                if let status = jsonDict["status"] as? Double {
                    //return error to callback
                    completionHandler(success: false, errorString: "No Account Found")
                }
                
                //did we get the user's info?
                if let user = jsonDict["user"] as? NSDictionary {
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.loggedUser.firstName = user["first_name"] as? String
                    appDelegate.loggedUser.lastName = user["last_name"] as? String
                    
                    completionHandler(success: true, errorString: nil)
                }
            }
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    func postUserLocation(completionHandler: (success: Bool, errorString: String?) -> Void) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var parameters = [String: AnyObject]()
        let url : String = ParseConstants.BaseURL + ParseMethods.StudentLocation
        let jsonBody : [String: AnyObject] = [
            "uniqueKey": appDelegate.loggedUser.accountId as String!,
            "firstName": appDelegate.loggedUser.firstName as String!,
            "lastName": appDelegate.loggedUser.lastName as String!,
            "mapString": appDelegate.loggedUser.mapString as String!,
            "mediaURL": appDelegate.loggedUser.mediaUrl!.absoluteString! as String!,
            "latitude": appDelegate.loggedUser.latitude as Double,
            "longitude": appDelegate.loggedUser.longitude as Double
        ]
        
        /* 2. Make the request */
        let task = taskForPOSTMethod(url, parameters: parameters, jsonBody: jsonBody) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(success: false, errorString: "Unable to Add Location Data")
            } else {
                
                if let errorString = JSONResult.valueForKey("error") as? String {
                    completionHandler(success: false, errorString: errorString)
                } else {
                    completionHandler(success: true, errorString: nil)
                }
            }
        }
    }
    
    func postUserData(accountId: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /* Chain completion handlers for each request so that they run one after the other */
        getAccountDetails(accountId) { (success, errorString) in
            
            if success {
                
                //now that we have the user's details, post their data to the Parse API
                self.postUserLocation() { (success, errorString) in
                    
                    if success {
                        
                        //we need to update the cache so our new location displays
                        self.getStudentLocations(true, completionHandler: { students, error in
                            if let students = students {
                                completionHandler(success: true, errorString: nil)
                            } else {
                                completionHandler(success: false, errorString: "Unable to update student cache after posting location")
                            }
                        })
                        
                    } else {
                        completionHandler(success: success, errorString: errorString)
                    }
                }
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
    }
}