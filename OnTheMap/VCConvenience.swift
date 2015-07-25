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
        presentViewController(controller, animated: true, completion: nil)
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
    
    // add custom styles to buttons
    func customizeButton(button: UIButton) {
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        button.backgroundColor = UIColor.whiteColor()
        button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        //Add some padding to our button
        //http://stackoverflow.com/questions/31353302/change-a-uibuttons-text-padding-programmatically-in-swift
        var padding = 5.0
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, CGFloat(padding))
        button.titleEdgeInsets = UIEdgeInsetsMake(0, CGFloat(padding), 0, 0)
        //adjust button width since we added some padding
        button.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
}