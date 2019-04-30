//
//  UIImageView+Extesnion.swift
//  Assignment
//
//  Created by Salman on 27/04/19.
//  Copyright © 2019 Salman. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func cacheImage(urlString: String) {
        let url = URL(string: urlString)
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        guard let stringUrl = url else { return }
        URLSession.shared.dataTask(with: stringUrl) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                    self.image = imageToCache
                }
            }
        }.resume()
    }
}
