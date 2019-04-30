//
//  HttpClient.swift
//  MVVM-C
//
//  Created by Salman Siddiqui on 27/02/19.
//  Copyright © 2019 SourceBits. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}


protocol URLSessionDataTaskProtocol {
    func resume()
}

final class HttpClient {
    typealias completeClosure = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func get(url: URL, callback: @escaping completeClosure) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            callback(data, response, error)
        }
        task.resume()
    }
}


extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSession.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request.url!, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
    
}
