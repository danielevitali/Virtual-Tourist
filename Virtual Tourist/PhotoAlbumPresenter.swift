//
//  PhotoAlbumPresenter.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import CoreData

class PhotoAlbumPresenter: PhotoAlbumContractPresenter {
    
    let view: PhotoAlbumContractView    
    let pin: Pin
    
    lazy var fetchedPhotosController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        //fetchRequest.predicate = NSPredicate(format: "pin.id = '\(self.pin.id)'")
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataManager.getInstance().coreDataStackManager.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return fetchedResultsController
    }()
    
    init(view: PhotoAlbumContractView, pin: Pin) {
        self.view = view
        self.pin = pin
        self.fetchedPhotosController.delegate = view
    }
    
    func onViewVisible() {
        do {
            try fetchedPhotosController.performFetch()
        } catch {}
        
        view.showPin(pin, span: 1000)
        if !pin.album.isEmpty {
            view.showPhotos()
            view.toggleActivityIndicator(false)
        } else {
            view.toggleActivityIndicator(true)
            view.hidePhotos()
            view.toggleNewCollectionButton(false)
            DataManager.getInstance().searchPhotos(pin, callback: { errorMessage in
                if let errorMessage = errorMessage {
                    self.view.showError(errorMessage)
                } else {
                    self.view.showPhotos()
                    self.view.toggleActivityIndicator(false)
                }
            })
        }
    }
    
    func onViewHidden() {
        
    }
    
    func photosChanged(photo: Photo, changeType: NSFetchedResultsChangeType, fromIndexPath: NSIndexPath?, toIndexPath: NSIndexPath?) {
        switch changeType {
        case .Insert:
            view.addPhoto(toIndexPath!)
        case .Delete:
            view.removePhoto(fromIndexPath!)
        case .Update:
            let photo = fetchedPhotosController.objectAtIndexPath(fromIndexPath!) as! Photo
            view.updatePhoto(photo, indexPath: fromIndexPath!)
        case .Move:
            view.movePhoto(fromIndexPath!, toIndexPath: toIndexPath!)
        }
    }
}