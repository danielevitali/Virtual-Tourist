//
//  PhotosResponse.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/30/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation

class PhotosResponse {
    
    let page: Int
    let pages: Int
    let perPage: Int
    let total: Int
    var photos: [PhotoResponse]
    
    init(response: NSDictionary) {
        self.photos = [PhotoResponse]()
        let photos = response["photos"] as! NSDictionary
        let array = photos["photo"] as! NSArray
        page = photos["page"] as! Int
        pages = photos["pages"] as! Int
        perPage = photos["perpage"] as! Int
        total = Int(photos["total"] as! String)!
        for element in array {
            self.photos.append(PhotoResponse(response: element as! NSDictionary))
        }
    }
    
}