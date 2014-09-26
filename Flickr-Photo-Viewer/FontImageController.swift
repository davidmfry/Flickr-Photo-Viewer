//
//  FontImageController.swift
//  Flickr-Photo-Viewer
//
//  Created by David Fry on 9/26/14.
//  Copyright (c) 2014 David Fry. All rights reserved.
//

import UIKit

class FrontImageController: NSObject, FlickrHelperProtocol
{
    // Get an image from flickr
    // send the image out with a protocol
    
    
    var frontImage: UIImage?
    var frontImageArray = []
    var frontPhotoSearchTermArray = ["cool places", "people", "music", "cars", "fashion", "good photography"]
    var searchURL = FlickrHelper()
    
    init(numberOfPhotos:Int)
    {
        super.init()
        self.searchURL.delegate = self
        self.searchURL.searchFlickrForString(self.frontPhotoSearchTermArray[0], numberOfPhotosPerPage: numberOfPhotos)
        
    }
    
    func didGetJsonData(result: NSArray)
    {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            println(result[0])
            var imageData = NSData(contentsOfURL: result[0] as NSURL)
            self.frontImage = UIImage(data: imageData)
            
        })
    }
    

    
}
