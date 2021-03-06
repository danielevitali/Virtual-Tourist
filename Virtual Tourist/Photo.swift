//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import CoreData

class Photo: NSManagedObject {
    
    @NSManaged var id: String
    @NSManaged var fileName: String?
    @NSManaged var url: String
    @NSManaged var location: Location
    
    init(photoResponse: PhotoResponse, context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        self.id = photoResponse.id
        self.url = photoResponse.url
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    override func prepareForDeletion() {
        if let fileName = fileName {
            FileSystemManager.getInstance().deletePhoto(fileName)
        }
    }
}