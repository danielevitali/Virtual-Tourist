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
    var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TravelLocationsMapPresenter(view: self)
        
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPressGesture:")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = annotation as! Pin
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: pin, reuseIdentifier: "pin")
            view!.canShowCallout = false
            view!.draggable = true
        } else {
            view!.annotation = pin
        }
        return view
    }
    
    func handleLongPressGesture(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .Began:
            let point = sender.locationInView(mapView)
            let coordinates = mapView.convertPoint(point, toCoordinateFromView:mapView)
            presenter.onLongClickOnMapBegin(coordinates.latitude, longitude: coordinates.longitude)
            break;
        case .Ended, .Cancelled:
            presenter.onLongClickOnMapEnd()
            break;
        default:
            break;
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch (newState) {
        case .Starting:
            view.dragState = .Dragging
        case .Ending, .Canceling:
            view.dragState = .None
            view.draggable = false
        default: break
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        presenter.onPinClick(view.annotation as! Pin)
    }
    
    func showPhotoAlbum(location: Location) {
        mapView.removeGestureRecognizer(longPressGestureRecognizer)
        let viewController = storyboard!.instantiateViewControllerWithIdentifier("PhotoAlbumViewController") as! PhotoAlbumViewController
        viewController.selectedLocation = location
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    func showError(message: String) {
        ErrorAlert(message: message).show(self)
    }
}

