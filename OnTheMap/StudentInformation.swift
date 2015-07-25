//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Ryan Rose on 7/5/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import Foundation
import MapKit

struct StudentInformation {
    var firstName : String?
    var lastName : String?
    var mediaUrl : String?
    var latitude : Double?
    var longitude : Double?
    //for adding pins to the map
    var annotation: MKPointAnnotation
    
    init?(dictionary: [String: AnyObject]) {
        if let s = dictionary["firstName"] as? String {
            self.firstName = s
        }
        if let s = dictionary["lastName"] as? String {
            self.lastName = s
        }
        if let s = dictionary["mediaURL"] as? String {
            self.mediaUrl = s
        }
        if let s = dictionary["longitude"] as? Double {
            //the longitude of the student location (ranges from -180 to 180)
            if s > -180.0 && s < 180.0 {
                self.longitude = CLLocationDegrees(s)
            }
        }
        if let s = dictionary["latitude"] as? Double {
            //the latitude of the student location (ranges from -90 to 90)
            if s > -90.0 && s < 90.0 {
                self.latitude = CLLocationDegrees(s)
            }
        }
        //set annotation properties for pin display
        annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
        annotation.title = self.title
        annotation.subtitle = self.subtitle
    }
    
    //computed property
    var title: String {
        return "\(firstName!) \(lastName!)"
    }
    
    var subtitle: String {
        return self.mediaUrl!
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of StudentInformation objects */
    static func studentsFromResults(results: [[String : AnyObject]]) -> [StudentInformation] {
        var students = [StudentInformation]()
        
        for result in results {
            students.append(StudentInformation(dictionary: result)!)
        }
        
        return students
    }
}