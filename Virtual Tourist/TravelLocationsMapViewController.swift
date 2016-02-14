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
    
    func showPins(locations: [Location]) {
        mapView.removeAnnotations(mapView.annotations)
        for location in locations {
            let pin = addPin(location.latitude as Double, longitude: location.longitude as Double, draggable: false)
            location.pin = pin
        }
    }
    
    func addPin(latitude: Double, longitude: Double, draggable: Bool) -> MKAnnotationView{
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotationView = MKAnnotationView()
        annotationView.annotation = annotation
        annotationView.draggable = draggable
        mapView.addAnnotation(annotation)
        return annotationView
    }
    
    func removePin(pin: MKAnnotationView) {
        mapView.removeAnnotation(pin.annotation!)
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
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        presenter.onPinClick(view)
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

