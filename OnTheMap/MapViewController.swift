//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Ryan Rose on 7/5/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class MapViewController : UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        self.navigationItem.rightBarButtonItems = self.setupNavBar()
        self.navigationItem.leftBarButtonItems = self.setupLogoutButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshLocations(false)
    }
    
    func refreshLocationsFromNav() {
        self.refreshLocations(true)
    }
    
    func refreshLocations(refresh: Bool) {
        OTMClient.sharedInstance().getStudentLocations(refresh, completionHandler: { students, error in
            if let students = students {
   
                //add pins to the map from student data returned from API
                for (var i = 0; i < students.count; i += 1) {
                    self.mapView.addAnnotation(students[i].annotation)
                }
                
                //force a repaint of the map and center it
                dispatch_async(dispatch_get_main_queue(), {
                    let center = self.mapView.centerCoordinate
                    self.mapView.centerCoordinate = center
                })
            } else {
                self.displayError("Unable to load data")
            }
        })
    }
    
}