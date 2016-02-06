//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Pin: NSManagedObject, MKAnnotation {
    
    @NSManaged var id: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var album: [Photo]
    @NSManaged var totalPagesCount: NSNumber?
    
    lazy var coordinate: CLLocationCoordinate2D = {
        return CLLocationCoordinate2D(latitude: self.latitude as Double, longitude: self.longitude as Double)
    }()
    
    init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        self.id = NSDate().timeIntervalSince1970
        self.latitude = latitude
        self.longitude = longitude
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}