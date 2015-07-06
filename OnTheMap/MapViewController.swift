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

class MapViewController : UIViewController, MKMapViewDelegate {
    
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
        // set initial location in Honolulu
        //let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        //centerMapOnLocation(initialLocation)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        OTMClient.sharedInstance().getStudentLocations { students, error in
            if let students = students {
                self.students = students
                /*
                dispatch_async(dispatch_get_main_queue()) {
                    self.moviesTableView.reloadData()
                }
                */
            } else {
                println(error)
            }
        }
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        let url = NSURL(string: view.annotation!.subtitle!)!
        
        UIApplication.sharedApplication().openURL(url)
    }
    
}