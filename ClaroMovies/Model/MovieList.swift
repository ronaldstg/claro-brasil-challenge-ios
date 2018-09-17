//
//  MovieList.swift
//  ClaroMovies
//
//  Created by Ronald on 10/09/18.
//  Copyright © 2018 br.com.claro. All rights reserved.
//

struct MovieList: Codable {
    let results: [Movie]?
    
    private enum CodingKeys: String, CodingKey {
        case results
    }
}
