//
//  PopularMovieRequest.swift
//  ClaroMovies
//
//  Created by Ronald on 04/09/18.
//  Copyright © 2018 br.com.claro. All rights reserved.
//

import Foundation

class PopularMoviesRequest: APIRequest {
    var method = RequestType.GET
    var path = "popular"
    var parameters = [String: String]()
}
