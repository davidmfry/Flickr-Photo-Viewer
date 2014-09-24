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
    
    class func URLForSearchString(searchString:String) -> String
    {
        let apiKey = "4338f93627883f4e8e8241f594a58b20"
        let search = searchString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(search!)&per_page=20&format=json&nojsoncallback=1"
        
    }
    
    class func URLForFlickrPhoto(photo:FlickrPhoto, size:String) -> String
    {
        var _size = size
        
        if _size.isEmpty
        {
            _size = "m"
        }
        
        return "https://farm\(photo.farm!).staticflickr.com/\(photo.server!)/\(photo.photoID!)_\(photo.secret!)_\(_size).jpg"
    }
    
    func searchFlickrForString(searchString:String)
    {
        let url = NSURL(string: FlickrHelper.URLForSearchString(searchString))
        var resultsDict: NSDictionary?
        
        let session = NSURLSession.sharedSession()
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
                    let status = jsonResult.objectForKey("stat") as String
                    
                    if status == "fail"
                    {
                        println("There was an Error with the Json Data you requested")
                    }
                    
                    else
                    {
                        var resultsArray = jsonResult.objectForKey("photos")?.objectForKey("photo") as NSArray
                        
                        var flickrPhotos = NSMutableArray()
                        
                        for photo in resultsArray
                        {
                            var photoDict = photo as NSDictionary
                            var flickrPhoto = FlickrPhoto()
                            
                            flickrPhoto.farm = photoDict.objectForKey("farm") as? Int
                            flickrPhoto.server = photoDict.objectForKey("server") as? String
                            flickrPhoto.secret = photoDict.objectForKey("secret") as? String
                            flickrPhoto.photoID = photoDict.objectForKey("id") as? String
                            
                            var imageURLStr = FlickrHelper.URLForFlickrPhoto(flickrPhoto, size: "b")
                            var imageURL = NSURL(string: imageURLStr)
                            var imageData = NSData(contentsOfURL: imageURL, options: nil, error: nil)
                            
                            var image = UIImage(data: imageData)
                            flickrPhoto.thumbnail = image
                            flickrPhotos.addObject(flickrPhoto)
                            
                        }
                        self.delegate?.didGetJsonData(flickrPhotos)
                    }
                    
                }
                
            }
        })
        
        task.resume()
        
    }
    
}
