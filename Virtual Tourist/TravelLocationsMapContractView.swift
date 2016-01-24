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

protocol TravelLocationsMapContractView: NSFetchedResultsControllerDelegate {
    
    var presenter: TravelLocationsMapContractPresenter! {get set}
 
    func showMapRegion(region: MapRegion)
    
    func addPin(pin: Pin)
    
    func removePin(pin: Pin)
}