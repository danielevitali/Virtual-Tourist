//
//  PhotoAlbumContractPresenter.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import CoreData

protocol PhotoAlbumContractPresenter {
 
    var view: PhotoAlbumContractView {get}
    var pin: Pin {get}
    var fetchedPhotosController: NSFetchedResultsController {get}
    
    func onViewVisible()
    
    func onViewHidden()
    
    func photosUpdate()
    
}