//
//  TravelLocationsMapContractPresenter.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import MapKit
import CoreData

protocol TravelLocationsMapContractPresenter {
    
    var view: TravelLocationsMapContractView {get}
    
    func onMapRegionChanged(region: MapRegion)
    
    func onLongClickOnMapBegin(latitude: Double, longitude: Double)
    
    func onLongClickOnMapEnd()
    
    func onPinClick(pin: MKAnnotationView)
    
}