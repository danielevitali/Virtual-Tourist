//
//  PhotosResponse.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/30/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation

class PhotosResponse {
    
    var photos: [PhotoResponse]
    
    init(response: NSDictionary) {
        self.photos = [PhotoResponse]()
        let array = response["photo"] as! NSArray
        for element in array {
            self.photos.append(PhotoResponse(response: element as! NSDictionary))
        }
    }
    
}