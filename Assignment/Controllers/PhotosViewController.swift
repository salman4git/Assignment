//
//  PhotosViewController.swift
//  Assignment
//
//  Created by Salman on 27/04/19.
//  Copyright © 2019 Salman. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: PhotosViewModel!
    var site: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activityIndicator.startAnimating()
        collectionView.isHidden = true
        viewModel = PhotosViewModel(delegate: self)
        viewModel.bind(text: site ?? "")
        collectionView.prefetchDataSource = self
    }
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: UICollectionViewDataSource
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.total
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCell = collectionView.dequeueResuableCell(for: indexPath)
        if isLoadingCell(for: indexPath) {
            cell.configureCell(stringUrl: "")
        } else {
            let url = viewModel.fetchedPhotoUrl[indexPath.item]
            cell.configureCell(stringUrl: url)
        }
        return cell
    }
}


extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 3
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.5, left: 0.5, bottom: 0.5, right: 0.5)
    }
}

extension PhotosViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchPhotos(search: site ?? "")
        }
    }
}

extension PhotosViewController: PhotosViewModelDelegate {
    func onFetchFailed(with reason: String) {
        print("Failed")
    }
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let _ = newIndexPathsToReload else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }
            return
        }
        collectionView.reloadData()
    }
}


private extension PhotosViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        print(indexPath.item)
        print(viewModel.currentCount)
        return indexPath.item >= viewModel.currentCount - 1
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
}
