//
//  FlickrHelper.swift
//  Flickr-Photo-Viewer
//
//  Created by David Fry on 9/22/14.
//  Copyright (c) 2014 David Fry. All rights reserved.
//

import UIKit


protocol FlickrHelperProtocol
{
    func didGetJsonData(result: NSArray)
}

class FlickrHelper: NSObject
{
    var delegate: FlickrHelperProtocol?
    
    class func URLForSearchString(searchString:String, numberOfPhotosPerPage:Int) -> String
    {
        // API from flickr
        let apiKey = "4338f93627883f4e8e8241f594a58b20"
        // User give string and it escapes spaces
        let search = searchString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        // Number of photos per page

        
        // The URL for doing the serach on the user given string
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(search!)&per_page=\(numberOfPhotosPerPage)&format=json&nojsoncallback=1"
        
    }
    
    class func URLForFlickrPhoto(photo:FlickrPhoto, size:String) -> String
    {
        // The size of the photos from flickr
        // see https://www.flickr.com/services/api/misc.urls.html
        var _size = size
        
        // Uses the medium size is none is given
        if _size.isEmpty
        {
            _size = "m"
        }
        
        // The URL for the photo file, most of the pramertes come from the FlickrPhoto object
        return "https://farm\(photo.farm!).staticflickr.com/\(photo.server!)/\(photo.photoID!)_\(photo.secret!)_\(_size).jpg"
    }
    
    func searchFlickrForString(searchString:String, numberOfPhotosPerPage:Int )
    {
        // gets the url data from flickr based on the string given
        let url = NSURL(string: FlickrHelper.URLForSearchString(searchString, numberOfPhotosPerPage: numberOfPhotosPerPage))
        
        // The shared session
        let session = NSURLSession.sharedSession()
        
        // The task we need to comeplete
        let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            if error != nil
            {
                println(error.localizedDescription)
            }
            else
            {
                // Parse JSON Data
                var err:NSError?
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                
                if err != nil
                {
                    println(error.localizedDescription)
                }
                else
                {
                    // Dict key for the status for the call we made to the flickr server "fail" or "ok"
                    let status = jsonResult.objectForKey("stat") as String
                    
                    if status == "fail"
                    {
                        // The error is the call failed
                        let messageString = jsonResult.objectForKey("message") as String
                        let error = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:messageString])
                        println(error)
                    }
                    
                    else
                    {
                        // An array that holds all of the photo dicts
                        var resultsArray = jsonResult.objectForKey("photos")?.objectForKey("photo") as NSArray
                        
                        // An array to hold flickrPhotos objects once we create them
                        var flickrPhotos = NSMutableArray()
                        
                        for photo in resultsArray
                        {
                            var photoDict = photo as NSDictionary
                            var flickrPhoto = FlickrPhoto()
                            
                            // Assigns flickr photo properties
                            flickrPhoto.farm = photoDict.objectForKey("farm") as? Int
                            flickrPhoto.server = photoDict.objectForKey("server") as? String
                            flickrPhoto.secret = photoDict.objectForKey("secret") as? String
                            flickrPhoto.photoID = photoDict.objectForKey("id") as? String
                            
                            // Assigns the flickrPhoto objects property for the image
                            var imageURLStr = FlickrHelper.URLForFlickrPhoto(flickrPhoto, size: "b")
                            var imageURL = NSURL(string: imageURLStr)

                            // Adds the object to the flickrPhotos array
                            flickrPhotos.addObject(imageURL)
                            
                        }
                        // Call the protocol method so it can pass the data to the delegate
                        self.delegate?.didGetJsonData(flickrPhotos)
                    }
                    
                }
                
            }
        })
        
        task.resume()
        
    }
    
}
