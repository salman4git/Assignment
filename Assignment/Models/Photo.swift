//
//  Photo.swift
//  Assignment
//
//  Created by Salman on 27/04/19.
//  Copyright © 2019 Salman. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    var photos: Photos
    
    struct Photos: Decodable {
        var page: Int
        var pages: Int
        var perpage: Int
        var photo: [PhotoDetail]?
    }
    
    struct PhotoDetail: Decodable {
       // var id: Int32
        var title: String?
        var url_o: String?
    }
}
