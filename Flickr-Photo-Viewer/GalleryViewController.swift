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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.flickrResults.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlickrCell", forIndexPath: indexPath) as FlickrCollectionViewCell
        
        cell.image = nil
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue, { () -> Void in
            var error:NSError?
            
            let searchURL = self.flickrResults.objectAtIndex(indexPath.item) as NSURL
            let imageData = NSData(contentsOfURL: searchURL, options: nil, error: &error)
            
            if error == nil
            {
                let image = UIImage(data: imageData)
                
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
        for view in self.collectionView.visibleCells()
        {
            var view = view as FlickrCollectionViewCell
            let yOffset = ((self.collectionView.contentOffset.y - view.frame.origin.y) / 160) * 25
            
            view.setImageOffset(CGPointMake(0, yOffset))
        }
    }
    
    func didGetJsonData(result: NSArray)
    {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.flickrResults = result as NSMutableArray
            self.collectionView.reloadData()
        })
    }
    



}
