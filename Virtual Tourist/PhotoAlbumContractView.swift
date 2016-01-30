//
//  PhotoAlbumContractView.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation
import CoreData

protocol PhotoAlbumContractView: NSFetchedResultsControllerDelegate {
    
    var presenter: PhotoAlbumContractPresenter! {get set}
    
    func showPin(pin: Pin, span: Double)
    
    func toggleActivityIndicator(visible: Bool)
    
    func hideAlbum()
    
    func showAlbum(photosCount: Int)
    
    func showError(message: String)
    
}