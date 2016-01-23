//
//  TravelLocationsMapView.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import MapKit

protocol TravelLocationsMapContractView {
    
    var presenter: TravelLocationsMapContractPresenter! {get set}
 
    func showMapRegion(region: MapRegion)
    
}