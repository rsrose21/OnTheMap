//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Ryan Rose on 6/21/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
    }
    
    func disableButtons(){
        loginButton.enabled = false
        signUpButton.enabled = false
    }
    
    func enableButtons(){
        loginButton.enabled = true
        signUpButton.enabled = true
    }
    
    @IBAction func login() {
        //validate text fields
        if loginTextField.text == "" {
            displayError("Please enter your email")
            return
        }
        if loginPassword.text == "" {
            displayError("Please enter your password")
            return
        }
        //show network activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        disableButtons()
        
        //Hide keyboard
        view.endEditing(true)
        
        OTMClient.sharedInstance().authenticateWithViewController(loginTextField.text, password: loginPassword.text) { (success, errorString) in
            //Hide network activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.enableButtons()
            if success {
                self.completeLogin()
            } else {
                self.displayError(errorString)
            }
        }
    }
    
    // MARK: - LoginViewController
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabViewController") as! UIViewController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == loginTextField) {
            loginPassword.becomeFirstResponder()
        }
        
        if (textField == loginPassword) {
            login()
        }
        
        return true;
    }
    
    @IBAction func loadSignUp(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: OTMClient.UdacityConstants.SignUpURL)!)
    }
    
}