//
//  AssignmentTests.swift
//  AssignmentTests
//
//  Created by Salman on 27/04/19.
//  Copyright © 2019 Salman. All rights reserved.
//

import XCTest
@testable import Assignment

class AssignmentTests: XCTestCase {
    
    var httpClient: HttpClient!
    var session: URLSessionProtocol?
    var listControllerUnderTest: PhotosViewController?
    var viewModel: PhotosViewModel?

    override func setUp() {
        session = MockURLSession()
        let viewModel = PhotosViewModel(delegate: self)
        viewModel.session = session
    }
    
    func test_FetchPhotoCount() {
        viewModel?.fetchedPhotoUrl = []
        XCTAssertNil(viewModel?.total)
    }
    
    
    func testCallPhotoList() {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        httpClient = HttpClient(session: session)
        let exception = expectation(description: "Status code: 200")
        httpClient.get(url: URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.apiKey)&format=json&nojsoncallback=1&text=kitten&extras=url_o&per_page=60&page=1")!) { (data, response, error) in
            // Check for error
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    guard let data = data else {
                        return
                    }
                    
                    XCTAssertNotNil(data)
                    do {
                        //create json object from data
                        if let _ = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {

                            exception.fulfill()
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                } else {
                    XCTFail("Status code error")
                }
                // Assert for data available...
                
            } else {
                XCTFail("Invalid Status code")
            }
        }
        wait(for: [exception], timeout: 15)
        
    }

    override func tearDown() {
        session = nil
        listControllerUnderTest = nil
    }
}


extension AssignmentTests: PhotosViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        XCTAssert(true, "Success")
    }
    
    func onFetchFailed(with reason: String) {
         XCTFail("Unable to fetch")
    }
}
