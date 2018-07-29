//
//  UIImageView-Extension.swift
//  Wikipedia App
//
//  Created by Anil Kumar on 28/07/18.
//  Copyright © 2018 Anil Kumar. All rights reserved.
//

import UIKit
import Alamofire


let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCache(withUrl urlString : String) {

        guard let url = URL(string: urlString) else {
            self.image = #imageLiteral(resourceName: "WikiPlaceholderIcon")
            return
        }
       
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
            
        }).resume()
    }
}
