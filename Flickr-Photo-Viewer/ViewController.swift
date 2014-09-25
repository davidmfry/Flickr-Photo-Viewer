//
//  ViewController.swift
//  Flickr-Photo-Viewer
//
//  Created by David Fry on 9/22/14.
//  Copyright (c) 2014 David Fry. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, FlickrHelperProtocol {


    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var imageView: UIImageView!
    
    var step = 0
    
    var photoListDict: NSDictionary?
    let flickerHelper = FlickrHelper()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.flickerHelper.delegate = self
        self.searchBar.becomeFirstResponder()
        self.searchBar.delegate = self

    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            if self.step == 0
            {
                self.imageView.transform = CGAffineTransformMakeScale(1.09, 1.09)
                self.step = 1
            }
            else
            {
                self.imageView.transform = CGAffineTransformIdentity
                self.step = 0
            }
            
        }, completion: nil)
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        self.searchBar.text = ""
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let destVC = segue.destinationViewController as GalleryViewController
        
        if !self.searchBar.text.isEmpty
        {
            destVC.searchTerm = self.searchBar.text
        }
        
        else
        {
            let alert = UIAlertController(title: "Ooops", message: "Please enter a search term!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    func didGetJsonData(result: NSArray)
    {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            println(result)
            
            
        })
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

