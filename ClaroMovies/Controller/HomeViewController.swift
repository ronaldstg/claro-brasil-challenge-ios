//
//  ViewController.swift
//  ClaroMovies
//
//  Created by Ronald on 04/09/18.
//  Copyright © 2018 br.com.claro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()
    let cellIdentifier = "moviecell"
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for movies"
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        navigationItem.title = "Claro Movies"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        bindUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    private func bindUI() {
        
        let apiClient = APIClient()
        
        searchController.searchBar.rx.text.asObservable()
            .map { ($0 ?? "").lowercased() }
            .map { PopularMoviesRequest(name: $0) }
            .flatMap { request -> Observable<[Movie]> in
                return apiClient.getMovie(apiRequest: request)
            }
            .bind(to: collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: MoviesCollectionViewCell.self)) { index, model, cell in
                
                if let posterPath = model.posterPath {
                    
                    let url = URL(string: APIClient.posterBaseUrl + posterPath)
                    let data = try? Data(contentsOf: url!)
                    
                    cell.movieImageView.image = UIImage(data: data!)
                }
            }
            .disposed(by: disposeBag)
    
    }
}

