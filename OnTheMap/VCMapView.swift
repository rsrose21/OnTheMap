//
//  VCMapView.swift
//  OnTheMap
//
//  Created by Ryan Rose on 7/5/15.
//  Copyright (c) 2015 GE. All rights reserved.
//  http://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    
    // 1
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        let url = NSURL(string: view.annotation!.subtitle!)!
        
        UIApplication.sharedApplication().openURL(url)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? StudentInformation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            return view
        }
        return nil
    }
}