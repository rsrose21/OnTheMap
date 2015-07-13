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

    @IBOutlet weak var debugTextLabel: UILabel!
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
        
        /* Configure the UI */
        self.configureUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //make sure debug text is empty
        self.debugTextLabel.text = ""
    }
    
    func configureUI() {
        /* Configure debug text label */
        debugTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)
        debugTextLabel.textColor = UIColor.whiteColor()
    }
    
    func disableButtons(){
        self.loginButton.enabled = false
        self.signUpButton.enabled = false
    }
    
    func enableButtons(){
        self.loginButton.enabled = true
        self.signUpButton.enabled = true
    }
    
    @IBAction func login() {
        //validate text fields
        if self.loginTextField.text == "" {
            self.displayError("Please enter your email")
            return
        }
        if self.loginPassword.text == "" {
            self.displayError("Please enter your password")
            return
        }
        //show network activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.disableButtons()
        
        //Hide keyboard
        self.view.endEditing(true)
        
        OTMClient.sharedInstance().authenticateWithViewController(self.loginTextField.text, password: self.loginPassword.text) { (success, errorString) in
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
            self.debugTextLabel.text = ""
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabViewController") as! UIViewController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = errorString {
                let alert = UIAlertController(title: nil, message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.loginTextField) {
            self.loginPassword.becomeFirstResponder()
        }
        
        if (textField == self.loginPassword) {
            login()
        }
        
        return true;
    }
    
    @IBAction func loadSignUp(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: OTMClient.UdacityConstants.SignUpURL)!)
    }
    
}