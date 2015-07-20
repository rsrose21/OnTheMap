//
//  PostInformationViewController.swift
//  OnTheMap
//
//  Created by Ryan Rose on 7/20/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import Foundation
import UIKit

class PostInformationViewController : UIViewController, UITextFieldDelegate {
    

    @IBAction func closeModal(sender: AnyObject) {
        //close modal viewcontroller
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}