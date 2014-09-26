//
//  GalleryViewController.swift
//  Flickr-Photo-Viewer
//
//  Created by David Fry on 9/25/14.
//  Copyright (c) 2014 David Fry. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, FlickrHelperProtocol
{

    @IBOutlet var collectionView: UICollectionView!
    
    let flickr = FlickrHelper()
    var searchTerm: String!
    
    var flickrResults = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.flickr.delegate = self
        self.flickr.searchFlickrForString(self.searchTerm)
        println(self.searchTerm)


    }
//MARK: #Collection View Delegate and Data source methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.flickrResults.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlickrCell", forIndexPath: indexPath) as FlickrCollectionViewCell
        
        cell.image = nil
        
        // Variable for the global queue
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue, { () -> Void in
            var error:NSError?
            
            // The URL for the image data
            let searchURL = self.flickrResults.objectAtIndex(indexPath.item) as NSURL
            // Puts the URL image data into an NSData variable
            let imageData = NSData(contentsOfURL: searchURL, options: nil, error: &error)
            
            if error == nil
            {
                // Variable to store the image
                let image = UIImage(data: imageData)
                
                // Starts and async download of the pictures
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell.image = image
                    
                    // Parallax offset
                    // the point at which the orgin of the content view is offset from the orgin of the scroll view
                    // ((orignOfTheContentViewPosY - currentFrameViewYPos) / cellHightWeDefined) * VelocityForTheScroll
                    let yOffset = ((collectionView.contentOffset.y - cell.frame.origin.y) / 160) * 25
                    cell.imageOffset = CGPointMake(0, yOffset)
                })
            }
        })
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        
        // Parallax offset
        // the point at which the orgin of the content view is offset from the orgin of the scroll view
        // ((orignOfTheContentViewPosY - currentFrameViewYPos) / cellHightWeDefined) * VelocityForTheScroll
        for view in self.collectionView.visibleCells()
        {
            var view = view as FlickrCollectionViewCell
            let yOffset = ((self.collectionView.contentOffset.y - view.frame.origin.y) / 160) * 25
            
            view.setImageOffset(CGPointMake(0, yOffset))
        }
    }
    
//MARK: #Custom Protocol Methods
    func didGetJsonData(result: NSArray)
    {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.flickrResults = result as NSMutableArray
            self.collectionView.reloadData()
        })
    }
    



}
