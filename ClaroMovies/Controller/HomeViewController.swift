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
import Kingfisher

class HomeViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()
    let cellIdentifier = "moviecell"
    let homeViewModel = HomeViewModel()
    
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
        
        collectionView.delegate = self
        bindUI(viewModel: homeViewModel)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    private func bindUI(viewModel: HomeViewModel) {
        
        let observable = self.searchController.searchBar
            .rx
            .text
            .orEmpty
            .throttle(0.2, scheduler: MainScheduler.instance)
            .asObservable()

        viewModel.bindObservableToFetchMovies(observable)
        
        viewModel.moviesList.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: MoviesCollectionViewCell.self)) { index, model, cell in
                
                if let posterPath = model.posterPath {
                    
                    let url = URL(string: APIClient.posterBaseUrl + posterPath)
                    cell.movieImageView.kf.indicatorType = .activity
                    cell.movieImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
                    
                    
                }
            }
            .disposed(by: disposeBag)

//            viewModel.isLoadingVariable.asObservable()
//                .bind { _ in
//
//                }
//                .disposed(by: disposeBag)
        
    }
    
    func loadingView() {
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge + 100 >= scrollView.contentSize.height) {
            print("LOAD MORE")
            homeViewModel.loadMoreMovies()
        }
    }
}

