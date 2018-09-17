//
//  HomeViewModel.swift
//  ClaroMovies
//
//  Created by Ronald on 10/09/18.
//  Copyright © 2018 br.com.claro. All rights reserved.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    let disposeBag = DisposeBag()
    let movieName = Variable<String>("")
    var moviesList = Variable<[Movie]>([])
    var isLoadingVariable = Variable(false)
    let apiClient = APIClient()
    var pageIndex = Variable<Int>(1)
    
    init() {

    }
    
    var isLoading: Observable<Bool> {
        return self.isLoadingVariable.asObservable()
    }
    
    func bindObservableToFetchMovies(_ observable: Observable<String>) {
        
        observable
            .map { ($0 ).lowercased() }
            .map {
                self.pageIndex.value = 1
                return PopularMoviesRequest(name: $0, page: 1)
            }
            .flatMap { request -> Observable<[Movie]> in
                return self.apiClient.getMovie(apiRequest: request)
            }
            .bind(to: self.moviesList)
            .disposed(by: disposeBag)
        
        
        
        // Setting searched keyword to movieName
        observable
            .map { ($0 ).lowercased() }
            .bind(to: self.movieName)
            .disposed(by: disposeBag)
    }
    
    func loadMoreMovies() {
        
        self.pageIndex.value += 1
        self.isLoadingVariable.value = true
        
        let request = PopularMoviesRequest(name: self.movieName.value, page: self.pageIndex.value)
        
        let result:Observable<[Movie]>
        result = self.apiClient.getMovie(apiRequest: request)
        
        result.asObservable()
            .subscribe(onNext: {
                self.moviesList.value.append(contentsOf: $0)
            }, onError: { (error) in
                print("an error occurred \(error.localizedDescription)")
            }, onCompleted: {
                self.isLoadingVariable.value = false //telling that finished
            })
            .disposed(by: disposeBag)
    }
}















