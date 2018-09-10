//
//  Movie.swift
//  ClaroMovies
//
//  Created by Ronald on 10/09/18.
//  Copyright © 2018 br.com.claro. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let title: String
    let posterPath: String
    
    private enum CodingKeys: String, CodingKey {
        case title
        case posterPath = "poster_path"
    }
}
