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
    var path = APIClient.movieSearchPath
    var parameters = [String: String]()
    
    init(name: String) {
        
        // If any name is set, then show Popular Movies List
        if (name == "") {
            path = APIClient.popularMoviesPath
        } else {
            parameters["query"] = name
        }
    }
}
