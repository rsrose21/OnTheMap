//
//  PostInformationViewController.swift
//  OnTheMap
//
//  Created by Ryan Rose on 7/20/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PostInformationViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var locationTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customise the submit button
        self.submitButton.layer.cornerRadius = 10
        self.submitButton.clipsToBounds = true
    }

    @IBAction func closeModal(sender: AnyObject) {
        //close modal viewcontroller
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findLocation(sender: AnyObject) {
        //Hide keyboard
        self.view.endEditing(true)
        
        //Try to geocode string
        var address = self.locationTextField.text
        
        //Display activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            //Hide activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            let placemakrs = $0
            let error = $1
            if let placemarks = $0 {
                
                if let placemark = placemakrs[0] as? CLPlacemark {
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.loggedUser.selectedLocation = MKPlacemark(placemark: placemark)
                    appDelegate.loggedUser.mapString = address
                    
                    println(address)
                    //update view
                }
                
            } else {
                //display alert to user
                self.displayError("Unable to find this location")
            }
        };
    }
}