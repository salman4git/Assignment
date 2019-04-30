//
//  PhotosViewModel.swift
//  Assignment
//
//  Created by Salman on 27/04/19.
//  Copyright © 2019 Salman. All rights reserved.
//

import Foundation
import UIKit

protocol PhotosViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}


final class PhotosViewModel {
    
    private weak var delegate: PhotosViewModelDelegate?
    
    var photo: Box<Photo?> = Box(nil)
    
    var numberOfPhotos: Box<Int> = Box(0)
    
    var session: URLSessionProtocol?
    
    var currentCount: Int {
        return fetchedPhotoUrl.count 
    }
    
    var fetchedPhotoUrl = [String]()
    
    private var isFetchInProgress = false
    private var currentPage = 1
    var total = 0
    
    let client = APINetworkManager(session: URLSession.shared)
    
    init(delegate: PhotosViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - API Call
    public func fetchPhotos(search: String) {
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        client.fetchFlickerPhotos(page: currentPage, search: search) { [weak self] photo in
            self?.isFetchInProgress = false
            self?.photo.value = photo
        }
    }
    
    // MARK: - Bind
    func bind(text: String) {
        fetchPhotos(search: text)
        photo.bind { photoObject in
            if let photoObject = photoObject {
                let photoUrl = photoObject.photos.photo?.compactMap { photo in
                    return photo.url_o
                }
                DispatchQueue.main.async {
                    if let photosURL = photoUrl, photosURL.count > 0 {
                        self.fetchedPhotoUrl.append(contentsOf: photosURL)
                        self.currentPage += 1
                        self.isFetchInProgress = false
                        self.total = photoUrl?.count ?? 0
                        
                        self.numberOfPhotos.value = photosURL.count
                        
                        if photoObject.photos.page > 1 {
                            let indexPathToReload = self.calculateIndexPathsToReload(from: photosURL)
                            self.delegate?.onFetchCompleted(with: indexPathToReload)
                        } else {
                            self.delegate?.onFetchCompleted(with: .none)
                        }
                    }
                }
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newPhotos: [String]) -> [IndexPath]? {
            let photosCount = fetchedPhotoUrl.count
            let startIndex = photosCount - newPhotos.count
            let endIndex = startIndex + newPhotos.count
            return (startIndex..<endIndex).map { IndexPath(item: $0, section: 0)}
    }
}
