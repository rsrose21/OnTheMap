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
                    println(status)
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
    
    // MARK: - GET Convenience Methods
    
    func getStudentLocations(completionHandler: (result: [StudentInformation]?, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var parameters = [String: AnyObject]()
        parameters["count"] = "1"
        // sort by create timestamp descending
        parameters["order"] = "-createdAt"

        /* 2. Make the request */
        taskForGETMethod(ParseMethods.StudentLocation, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = JSONResult.valueForKey("results") as? [[String : AnyObject]] {
                    println(results)
                    //var movies = TMDBMovie.moviesFromResults(results)
                    var students = [StudentInformation]()
                    completionHandler(result: students, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }
}