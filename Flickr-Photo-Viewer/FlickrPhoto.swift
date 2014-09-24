//
//  FlickrPhoto.swift
//  Flickr-Photo-Viewer
//
//  Created by David Fry on 9/24/14.
//  Copyright (c) 2014 David Fry. All rights reserved.
//

import UIKit

class FlickrPhoto: NSObject
{
    var thumbnail: UIImage?
    var largeImage: UIImage?
    
    var photoID: String?
    var farm: Int?
    var server: String?
    var secret: String?
    
    override init ()
    {

    }
}
