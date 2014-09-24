//
//  ViewController.swift
//  Flickr-Photo-Viewer
//
//  Created by David Fry on 9/22/14.
//  Copyright (c) 2014 David Fry. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FlickrHelperProtocol {

    @IBOutlet var imageView: UIImageView!
    var photoListDict: NSDictionary?
    let flickerHelper = FlickrHelper()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.flickerHelper.delegate = self
        self.flickerHelper.searchFlickrForString("world")

    }
    
    func didGetJsonData(result: NSArray)
    {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            println(result)
            
            var firstImage = result[0] as FlickrPhoto
            self.imageView.image = firstImage.thumbnail
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

