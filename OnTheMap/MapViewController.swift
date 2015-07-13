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
    
    var students: [StudentInformation] = [StudentInformation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    //define a rectangular region to get proper zoom radius
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        //UINavigationController(rootViewController: MapViewController())
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
                //add pins to the map from student data returned from API
                self.mapView.addAnnotations(self.students)
                
                //force a repaint of the map and center it
                dispatch_async(dispatch_get_main_queue(), {
                    let center = self.mapView.centerCoordinate
                    self.mapView.centerCoordinate = center
                })
            } else {
                self.displayError("Unable to load data")
            }
        }
    }
    
}