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
    //    private let baseURL = URL(string: "http://universities.hipolabs.com/")!
    private let baseURL = URL(string: "https://api.themoviedb.org/3/movie/")!
    //    private let baseURL = URL(string: "http://localhost:8080/movie/")!
    
    /// poster base URL
    static var posterBaseUrl: String {
        return "https://image.tmdb.org/t/p/w500"
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
                    print("OK")
                    
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
