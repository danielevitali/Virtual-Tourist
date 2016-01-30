//
//  PhotoAlbumContractPresenter.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/23/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation

protocol PhotoAlbumContractPresenter {
 
    var view: PhotoAlbumContractView {get}
    var photosCount: Int? {get}
    
    func onViewVisible()
    
    func onViewHidden()
    
}