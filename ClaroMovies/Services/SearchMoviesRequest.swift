//
//  SearchMoviesRequest.swift
//  ClaroMovies
//
//  Created by Ronald on 04/09/18.
//  Copyright © 2018 br.com.claro. All rights reserved.
//

import Foundation

class SearchMoviesRequest: APIRequest {
    var method = RequestType.GET
    var path = "search/movie"
    var parameters = [String: String]()
    
    init(name: String) {
        parameters["api_key"] = "530dea27c211e00f4c65c5a45907e773"
    }
}
