//
//  PhotoCell.swift
//  Assignment
//
//  Created by Salman on 27/04/19.
//  Copyright © 2019 Salman. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    func configureCell(stringUrl: String?) {
        if let url = stringUrl {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.photoImageView.cacheImage(urlString: url)
                self.activityIndicator.isHidden = true
            }
        } else {
            activityIndicator.startAnimating()
        }
    }
}

extension PhotoCell: ReusableView {}
