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
    
    var students: [StudentInformation] = [StudentInformation]()
    
    @IBOutlet var tableData: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItems = self.setupNavBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshLocations()
    }
    
    func refreshLocations() {
        OTMClient.sharedInstance().getStudentLocations { students, error in
            if let students = students {
                self.students = students
                dispatch_async(dispatch_get_main_queue(), {
                    //now that we have data, reload the tableView
                    self.tableView.reloadData()
                })
            } else {
                self.displayError("Unable to load data")
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return cell count for tableView
        return self.students.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath) as! UITableViewCell
        
        var student = self.students[indexPath.item] as StudentInformation
        
        cell.textLabel?.text = student.title
        cell.imageView?.image = UIImage(named: "pin")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = self.students[indexPath.item] as StudentInformation
        let url = NSURL(string: student.subtitle)!
        
        UIApplication.sharedApplication().openURL(url)
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}