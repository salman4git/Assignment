//
//  APINetworkManager.swift
//  Assignment
//
//  Created by Salman on 27/04/19.
//  Copyright © 2019 Salman. All rights reserved.
//

import Foundation


class APINetworkManager {
    
    var httpClient: HttpClient?
    var session: URLSessionProtocol?
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func fetchFlickerPhotos(page: Int, search: String, photos: @escaping (_ photos: Photo) -> Void) {
        //create the url with URL
        let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.apiKey)&format=json&nojsoncallback=1&text=\(search)&extras=url_o&per_page=60&page=\(page)")! //change the url
        
        //create the session object
        
        
        httpClient = HttpClient(session: session!)
        httpClient?.get(url: url) { (data, response, error) in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    let json = try JSONDecoder().decode(Photo.self, from: data)
                    photos(json)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
