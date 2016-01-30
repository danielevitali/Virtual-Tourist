//
//  PhotoAlbumPresenter.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation

class PhotoAlbumPresenter: PhotoAlbumContractPresenter {
    
    let view: PhotoAlbumContractView
    var photosCount: Int?
    
    private let pin: Pin
    
    init(view: PhotoAlbumContractView, pin: Pin) {
        self.view = view
        self.pin = pin
    }
    
    func onViewVisible() {
        view.showPin(pin, span: 100)
        view.toggleActivityIndicator(true)
        view.hideAlbum()
        DataManager.getInstance().searchPhotos(pin, photosCountCallback: { (count, errorMessage) -> Void in
            self.photosCount = count
            self.view.toggleActivityIndicator(false)
            if let count = count {
                self.view.showAlbum(count)
            } else {
                self.view.showError(errorMessage!)
            }
            },
            photosCallback: { (photos, errorMessage) -> Void in
                //TODO show images
        })
    }
    
    func onViewHidden() {
        
    }
    
}