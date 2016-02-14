//
//  Location.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 2/14/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Location: NSManagedObject {
    
    @NSManaged var id: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var album: [Photo]
    @NSManaged var totalPagesCount: NSNumber?
    
    var pin: MKAnnotationView?
    
    init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Location", inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        self.id = NSDate().timeIntervalSince1970
        self.latitude = latitude
        self.longitude = longitude
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
}