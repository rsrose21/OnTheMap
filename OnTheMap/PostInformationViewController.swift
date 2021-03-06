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

class PostInformationViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var mapUIView: UIView!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var locationTextField: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
        urlTextField.delegate = self
        
        //hide our map view and show the text entry view on load
        locationView.hidden = false
        mapUIView.hidden = true
        
        configureUI()
    }
    
    func configureUI() {
        //customize the submit button
        customizeButton(submitButton)
        customizeButton(findButton)
        
        //set placeholder text for UITextView
        locationTextField.text = "Enter Location"
        locationTextField.textColor = UIColor.whiteColor()
        //URLs should start with a protocol
        urlTextField.text = "http://"
    }

    @IBAction func closeModal(sender: AnyObject) {
        //close modal viewcontroller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findLocation(sender: AnyObject) {
        //Hide keyboard
        view.endEditing(true)
        
        //Try to geocode string
        var address = locationTextField.text
        
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
                    
                    //add location entered to map and display
                    self.mapView.addAnnotation(appDelegate.loggedUser.selectedLocation)
                    self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                    //update view
                    self.locationView.hidden = true
                    self.mapUIView.hidden = false
                }
                
            } else {
                //display alert to user
                self.displayError("Unable to find this location")
            }
        };
    }
    
    @IBAction func submit() {
        //Hide the keyboard
        view.endEditing(true)
        
        //Disable button
        submitButton.enabled = false
        
        //Validate URL
        var addedUrl = urlTextField.text
        
        if isValidUrl(addedUrl) {
            //Url valid
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.loggedUser.mediaUrl = NSURL(string: addedUrl)
            
            //Show network activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            //save data
            OTMClient.sharedInstance().postUserData(appDelegate.loggedUser.accountId!) { (success, errorString) in
                //Hide network activity indicator
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if success {
                    //close modal view
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.displayError(errorString)
                }
            }
        } else {
            displayError("Please enter a valid URL")
        }
    }
    
    /**
    * Method is meant to validate the URL address. It checks whether connection can be made to the supplied URL address.
    * Method will return false either if url is not valid or connection to the URL address cannot be made (due to the network failure
    * for example). (http://stackoverflow.com/questions/1471201/how-to-validate-an-url-on-the-iphone)
    */
    func validateUrl (stringURL : NSString) -> Bool {
        
        var urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        var urlTest = NSPredicate.predicateWithSubstitutionVariables(predicate)
        
        return predicate.evaluateWithObject(stringURL)
    }
    
    func isValidUrl(url: String) -> Bool {
        //first test if we have a proper URL string
        let valid = validateUrl(url)
        if (valid) {
            //check whether connection can be made to the supplied URL address
            let request = NSURLRequest(URL: NSURL(string: url)!)
            
            return NSURLConnection.canHandleRequest(request)
        } else {
            return false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == urlTextField){
            submit()
        }
        
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Enter Location" {
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Location"
        }
    }

}