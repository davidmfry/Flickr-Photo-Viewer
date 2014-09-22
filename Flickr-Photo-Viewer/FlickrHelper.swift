//
//  FlickrHelper.swift
//  Flickr-Photo-Viewer
//
//  Created by David Fry on 9/22/14.
//  Copyright (c) 2014 David Fry. All rights reserved.
//

import UIKit

class FlickrHelper: NSObject
{
    class func URLForSearchString(searchString:String) -> String
    {
        let apiKey = "4338f93627883f4e8e8241f594a58b20"
        let search = searchString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        return "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=\(apiKey)&text=\(search)&per_page=20&format=json&nojsoncallback=1"
        
    }
}
