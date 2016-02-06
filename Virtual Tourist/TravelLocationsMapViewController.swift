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
    var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TravelLocationsMapPresenter(view: self)
        
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPressGesture:")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        presenter.onViewVisible()
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        mapView.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: true)
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
        mapView.setRegion(coordinateRegion, animated: false)
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
    
    func showPins(pins: [Pin]) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(pins)
    }
    
    func addPin(pin: Pin) {
        mapView.addAnnotation(pin)
    }
    
    func removePin(pin: Pin) {
        mapView.removeAnnotation(pin)
    }
    
    func showPhotoAlbum(pin: Pin) {
        mapView.removeGestureRecognizer(longPressGestureRecognizer)
        let viewController = storyboard!.instantiateViewControllerWithIdentifier("PhotoAlbumViewController") as! PhotoAlbumViewController
        viewController.selectedPin = pin
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    func showError(message: String) {
        ErrorAlert(message: message).show(self)
    }
}

