//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsMapViewController: UIViewController, TravelLocationsMapContractView, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var presenter: TravelLocationsMapContractPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TravelLocationsMapPresenter(view: self)
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
}

