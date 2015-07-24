//
//  VCConvenience.swift
//  OnTheMap
//
//  Created by Ryan Rose on 7/13/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = errorString {
                let alert = UIAlertController(title: nil, message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    func setupNavBar() -> [UIBarButtonItem] {
        //create buttons to add to nav bar
        let pinButton = UIBarButtonItem(image: UIImage(named: "pin.pdf"), style: .Plain, target: self, action: Selector("addLocation"))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: Selector("refreshLocationsFromNav"))
        
        return [refreshButton, pinButton]
    }
    
    func setupLogoutButton() -> [UIBarButtonItem] {
        //create buttons to add to nav bar
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: Selector("logout"))
        
        return [logoutButton]
    }
    
    func addLocation() {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("PostNavigationController") as! UIViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func logout() {
        //Show network activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        OTMClient.sharedInstance().logoutUser() { (success, errorString) in
            //Hide network activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if success {
                let controller = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
                self.presentViewController(controller, animated: true, completion: nil)
            } else {
                self.displayError(errorString)
            }
        }
    }
    
}