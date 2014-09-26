//
//  FlickrCollectionViewCell.swift
//  Flickr-Photo-Viewer
//
//  Created by David Fry on 9/25/14.
//  Copyright (c) 2014 David Fry. All rights reserved.
//

import UIKit

class FlickrCollectionViewCell: UICollectionViewCell
{
    var imageView:UIImageView!
    var image:UIImage!{
        get{
          return self.image
        }
        
        set{
            self.imageView.image = newValue
            if imageOffset != nil
            {
                // set imageOffset
                self.setImageOffset(imageOffset)
            }
            else
            {
                // set imageOffset to (0,0)
                self.setImageOffset(CGPointMake(0, 0))
            }
        }
    }
    
    var imageOffset:CGPoint!
    
    override init(frame:CGRect)
    {
        super.init(frame: frame)
        self.setupImageView()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.setupImageView()
    }
    
    func setupImageView()
    {
        self.clipsToBounds = true
        
        // creates the imageView with frame size
        self.imageView = UIImageView(frame: CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 320, 160))
        
        // sets the content mode IE: in the right pane under view -> mode
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.imageView.clipsToBounds = false
        
        // Adds the view to the cell
        self.addSubview(self.imageView)
        
    }
    
    func setImageOffset(imageOffset:CGPoint)
    {
        self.imageOffset = imageOffset
        let frame = self.imageView.bounds
        let offsetFrame = CGRectOffset(frame, self.imageOffset.x, self.imageOffset.y)
        
        self.imageView.frame = offsetFrame
    }
    
    
}
