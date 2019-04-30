//
//  MockURLSession.swift
//  MVVM-C
//
//  Created by Salman Siddiqui on 27/02/19.
//  Copyright © 2019 SourceBits. All rights reserved.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}

class MockURLSession: URLSessionProtocol {
    
    private (set) var lastURL: URL?
    
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping MockURLSession.DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        completionHandler(nextData, successHttpURLResponse(request: request), nextError)
        return nextDataTask
    }
}
