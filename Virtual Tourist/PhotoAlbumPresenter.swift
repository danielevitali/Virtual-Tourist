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
    
    init(view: PhotoAlbumContractView, pin: Pin) {
        self.view = view
        self.pin = pin
    }
    
    func onViewVisible() {
        view.showPin(pin, span: 1000)
        if pin.photos != nil {
            view.showPhotos()
            view.toggleActivityIndicator(false)
        } else {
            view.toggleActivityIndicator(true)
            view.hidePhotos()
            view.toggleNewCollectionButton(false)
            DataManager.getInstance().searchPhotos(pin, delegate: view) { (errorMessage) -> Void in
                self.view.showError(errorMessage)
            }
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
            view.updatePhoto(pin.photos![fromIndexPath!.row], indexPath: fromIndexPath!)
        case .Move:
            view.movePhoto(fromIndexPath!, toIndexPath: toIndexPath!)
        }
    }
}