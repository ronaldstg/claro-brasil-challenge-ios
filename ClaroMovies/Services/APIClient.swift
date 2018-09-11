//
//  APIClient.swift
//  ClaroMovies
//
//  Created by Ronald on 04/09/18.
//  Copyright © 2018 br.com.claro. All rights reserved.
//

import Foundation
import RxSwift

class APIClient {
    private let baseURL = URL(string: "https://api.themoviedb.org/3/")!
    
    static var apiKey: String{
        return "530dea27c211e00f4c65c5a45907e773"
    }
    
    // poster base URL
    static var posterBaseUrl: String {
        return "https://image.tmdb.org/t/p/w500"
    }
    
    // movies search path
    static var movieSearchPath: String {
        return "search/movie"
    }
    
    // popular movies path
    static var popularMoviesPath: String {
        return "movie/popular"
    }
    
    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { [unowned self] observer in
            let request = apiRequest.request(with: self.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func getMovie(apiRequest:APIRequest) -> Observable<[Movie]> {
        return Observable<[Movie]>.create { [unowned self] observer in
            let request = apiRequest.request(with: self.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let movieList: MovieList = try JSONDecoder().decode(MovieList.self, from: data ?? Data())                    
                    let model: [Movie] = movieList.results
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
