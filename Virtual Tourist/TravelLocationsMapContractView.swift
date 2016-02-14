//
//  TravelLocationsMapView.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import MapKit
import CoreData

protocol TravelLocationsMapContractView {
    
    var presenter: TravelLocationsMapContractPresenter! {get set}
 
    func showMapRegion(region: MapRegion)
    
    func addPin(latitude: Double, longitude: Double, draggable: Bool) -> MKAnnotationView
    
    func removePin(pin: MKAnnotationView)
    
    func showPhotoAlbum(location: Location)
    
    func showPins(locations: [Location])
    
    func showError(message: String)
    
}