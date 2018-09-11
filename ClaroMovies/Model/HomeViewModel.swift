//
//  HomeViewModel.swift
//  ClaroMovies
//
//  Created by Ronald on 10/09/18.
//  Copyright © 2018 br.com.claro. All rights reserved.
//

import Foundation
import RxSwift

struct HomeViewModel {
    
    let disposeBag = DisposeBag()
    let movieName = BehaviorSubject(value: "")
    var moviesList = Variable<[Movie]>([])
    
    init() {
        
        let apiClient = APIClient()
        
        
        movieName.asObserver()
        .map { ($0 ).lowercased() }
        .map { PopularMoviesRequest(name: $0) }
        .flatMap { request -> Observable<[Movie]> in
            return apiClient.getMovie(apiRequest: request)
        }
        .bind(to: self.moviesList)
        .disposed(by: disposeBag)
        
    }
}
