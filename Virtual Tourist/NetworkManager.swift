//
//  NetworkManager.swift
//  Virtual Tourist
//
//  Created by Daniele Vitali on 1/30/16.
//  Copyright © 2016 Daniele Vitali. All rights reserved.
//

import Foundation

class NetworkManager {
    
    private static let BASE_URL = "https://api.flickr.com/services/rest"
    private static let SEARCH_METHOD_NAME = "flickr.photos.search"
    private static let API_KEY = "0a0e10c407bc913ac05501cc1656648d"
    private static let GALLERY_ID = "5704-72157622566655097"
    private static let DATA_FORMAT = "json"
    private static let NO_JSON_CALLBACK = "1"
    private static let EXTRAS = "url_m"
    
    private static let BOUNDING_BOX_HALF_WIDTH = 1.0
    private static let BOUNDING_BOX_HALF_HEIGHT = 1.0
    private static let LAT_MIN = -90.0
    private static let LAT_MAX = 90.0
    private static let LON_MIN = -180.0
    private static let LON_MAX = 180.0
    
    private static let instance = NetworkManager()
    
    private let sharedSession: NSURLSession!
    
    static func getInstance() -> NetworkManager {
        return instance
    }
    
    private init() {
        sharedSession = NSURLSession.sharedSession()
    }
    
    func searchPhotos(latitude: Double, longitude: Double, callback: (photosResponse: PhotosResponse?, errorResponse: ErrorResponse?) -> Void) {
        var methodParams = buildDefaultRequestParameters()
        methodParams["bbox"] = createBoundingBoxString(latitude: latitude, longitude: longitude)
        let url = buildUrl(methodParams)
        executeGetRequest(url, completionHandler: { (data, response, error) in
            if let response = response, let data = data {
                let json = self.extractJson(data)
                if self.isSuccessResponse(response.statusCode) {
                    let response = PhotosResponse(response: json)
                    callback(photosResponse: response, errorResponse: nil)
                } else {
                    let errorResponse = ErrorResponse(response: json)
                    callback(photosResponse: nil, errorResponse: errorResponse)
                }
            } else {
                let errorResponse = ErrorResponse(error: error!)
                callback(photosResponse: nil, errorResponse: errorResponse)
            }
        })
    }
    
    func downloadPhoto(url: NSURL, callback: ((imageData: NSData?, errorResponse: ErrorResponse? ) -> Void)) {
        executeGetRequest(url, completionHandler: { (data, response, error) in
            if let data = data {
                callback(imageData: data, errorResponse: nil)
            } else {
                let errorResponse = ErrorResponse(error: error!)
                callback(imageData: nil, errorResponse: errorResponse)
            }
        })
    }
    
    private func buildUrl(params: [String:String]) -> NSURL {
        return NSURL(string: (NetworkManager.BASE_URL + escapedParameters(params)))!
    }
    
    private func buildDefaultRequestParameters() -> [String : String] {
        return [
            "method": NetworkManager.SEARCH_METHOD_NAME,
            "api_key": NetworkManager.API_KEY,
            "format": NetworkManager.DATA_FORMAT,
            "gallery_id": NetworkManager.GALLERY_ID,
            "nojsoncallback": NetworkManager.NO_JSON_CALLBACK,
            "extras": NetworkManager.EXTRAS
        ]
    }
    
    private func createBoundingBoxString(latitude latitude: Double, longitude: Double) -> String {
        let bottomLeftLon = max(longitude - NetworkManager.BOUNDING_BOX_HALF_WIDTH, NetworkManager.LON_MIN)
        let bottomLeftLat = max(latitude - NetworkManager.BOUNDING_BOX_HALF_HEIGHT, NetworkManager.LAT_MIN)
        let topRightLon = min(longitude + NetworkManager.BOUNDING_BOX_HALF_HEIGHT, NetworkManager.LON_MAX)
        let topRightLat = min(latitude + NetworkManager.BOUNDING_BOX_HALF_HEIGHT, NetworkManager.LAT_MAX)
        return "\(bottomLeftLon),\(bottomLeftLat),\(topRightLon),\(topRightLat)"
    }
    
    private func executeGetRequest(url: NSURL, completionHandler: (data:NSData?, response: NSHTTPURLResponse?, error:NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: url)
        sharedSession.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) in
            completionHandler(data: data, response: response as? NSHTTPURLResponse, error: error)
        }).resume()
    }
    
    private func escapedParameters(parameters: [String:String]) -> String {
        var urlVars = [String]()
        for (key, value) in parameters {
            let escapedValue = "\(value)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        return (urlVars.isEmpty ? "" : "?") + urlVars.joinWithSeparator("&")
    }
    
    private func extractJson(data: NSData) -> NSDictionary {
        return try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
    }
    
    private func isSuccessResponse(statusCode: Int) -> Bool {
        return statusCode/100 == 2
    }
}
