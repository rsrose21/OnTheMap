//
//  TabViewController.swift
//  OnTheMap
//
//  Created by Ryan Rose on 7/5/15.
//  Copyright (c) 2015 GE. All rights reserved.
//
import UIKit
import Foundation

class TabViewController : UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //update title in navigation bar
        title = "On The Map"
        navigationItem.rightBarButtonItems = setupNavBar()
        navigationItem.leftBarButtonItems = setupLogoutButton()
    }
}