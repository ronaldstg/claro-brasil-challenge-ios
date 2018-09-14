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
    var isLoadingVariable = Variable(true)
    let apiClient = APIClient()
    
    init() {

    }
    
    var isLoading: Observable<Bool> {
        return self.isLoadingVariable.asObservable()
    }
    
    func bindObservableToFetchMovies(_ observable: Observable<String>) {
        
        observable
            .map { ($0 ).lowercased() }
            .map { PopularMoviesRequest(name: $0) }
            .flatMap { request -> Observable<[Movie]> in
                return self.apiClient.getMovie(apiRequest: request)
            }
            .bind(to: self.moviesList)
            .disposed(by: disposeBag)
        
       
//        self.moviesList.asObservable()
//            .bind { movie in
//                self.isLoadingVariable.value = movie.isEmpty
//        }
    }
    
    func loadMoreMovies() {
        self.moviesList.value.append(Movie(title: "TESTE", posterPath: "/IfB9hy4JH1eH6HEfIgIGORXi5h.jpg"))
    }

}
