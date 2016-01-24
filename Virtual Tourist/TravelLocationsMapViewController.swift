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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TravelLocationsMapPresenter(view: self)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: mapView, action: "handleLongPressGesture:")
        mapView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        presenter.onViewVisible()
        mapView.delegate = self
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let rect = mapView.visibleMapRect
        let region = MapRegion(latitude: rect.origin.x, originY: rect.origin.y, width: rect.size.width, height: rect.size.height)
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
            
            let pin = DataManager.getInstance().createPin(coordinates.latitude, longitude: coordinates.longitude)
            
            let location = CLLocationCoordinate2DMake(pin.latitude, pin.longitude)
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = location
            mapView.addAnnotation(dropPin)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        presenter.onDataChange(type, oldIndexPath: indexPath, newIndexPath: newIndexPath)
    }
    
    func showNewPinsAtIndexPaths(indexPaths: [NSIndexPath]) {
        
        tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
    }
    
    func removePinsAtIndexPaths(indexPaths: [NSIndexPath]) {
        tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
    }
    
    func updatePinAtIndexPath(indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath!) as! ActorTableViewCell
        let movie = controller.objectAtIndexPath(indexPath!) as! Movie
        self.configureCell(cell, movie: movie)
    }
}

