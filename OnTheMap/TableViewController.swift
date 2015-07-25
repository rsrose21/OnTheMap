//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Ryan Rose on 7/13/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import Foundation
import UIKit

class TableViewController : UITableViewController {
    
    var client: OTMClient!
    @IBOutlet var tableData: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get a reference to our client instance, which provides access to the student data
        client = OTMClient.sharedInstance()
        //set navigation bar buttons
        navigationItem.rightBarButtonItems = setupNavBar()
        navigationItem.leftBarButtonItems = setupLogoutButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //load data, will pull from cache if already set
        refreshLocations(false)
    }
    
    func refreshLocationsFromNav() {
        //force a call for new data
        refreshLocations(true)
    }
    
    func refreshLocations(refresh: Bool) {
        client.getStudentLocations(refresh, completionHandler: { students, error in
            if let students = students {
                
                dispatch_async(dispatch_get_main_queue(), {
                    //now that we have data, reload the tableView
                    self.tableView.reloadData()
                })
            } else {
                self.displayError("Unable to load data")
            }
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return cell count for tableView
        return client.students.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath) as! UITableViewCell
        
        var student = OTMClient.sharedInstance().students[indexPath.item] as StudentInformation
        
        cell.textLabel?.text = student.title
        cell.imageView?.image = UIImage(named: "pin")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = client.students[indexPath.item] as StudentInformation
        let url = NSURL(string: student.subtitle)!
        
        UIApplication.sharedApplication().openURL(url)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}