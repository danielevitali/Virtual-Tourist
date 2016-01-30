//
//  TravelLocationsMapViewController.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsMapViewController: UIViewController, TravelLocationsMapContractView, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var presenter: TravelLocationsMapContractPresenter!
    var selectedPin: Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TravelLocationsMapPresenter(view: self)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPressGesture:")
        mapView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        presenter.onViewVisible()
        mapView.delegate = self
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let rect = mapView.visibleMapRect
        let region = MapRegion(originX: rect.origin.x, originY: rect.origin.y, width: rect.size.width, height: rect.size.height)
        presenter.onMapRegionChanged(region)
    }
    
    func showMapRegion(region: MapRegion) {
        let mapPoint = MKMapPoint(x: region.originX, y: region.originY)
        let mapSize = MKMapSize(width: region.width, height: region.height)
        let mapRect = MKMapRect(origin: mapPoint, size: mapSize)
        let coordinateRegion = MKCoordinateRegionForMapRect(mapRect)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func handleLongPressGesture(sender: UILongPressGestureRecognizer) {
        if sender.state != .Ended {
            let point = sender.locationInView(mapView)
            let coordinates = mapView.convertPoint(point, toCoordinateFromView:mapView)
            presenter.onLongClickOnMap(coordinates.latitude, longitude: coordinates.longitude)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        let pin = anObject as! Pin
        presenter.onDataChange(pin, forChangeType: type)
    }
    
    func addPin(pin: Pin) {
        mapView.addAnnotation(pin)
    }
    
    func removePin(pin: Pin) {
        mapView.removeAnnotation(pin)
    }
    
    func showPhotoAlbum(pin: Pin) {
        selectedPin = pin
        performSegueWithIdentifier("photoAlbumSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController = segue.destinationViewController as! PhotoAlbumViewController
        viewController.selectedPin = selectedPin
    }
}

