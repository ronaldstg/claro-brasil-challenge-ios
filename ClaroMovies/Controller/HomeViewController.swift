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

class HomeViewController: UIViewController, UICollectionViewDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()
    let cellIdentifier = "moviecell"
    let homeViewModel = HomeViewModel()
    var searchActive: Bool = false
    var searchTerm:String!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var headerContainerHeightConstraint: NSLayoutConstraint!
    
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
        
        searchController.searchBar.delegate = self
        
        collectionView.delegate = self
        bindUI(viewModel: homeViewModel)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: RX BINDING
    private func bindUI(viewModel: HomeViewModel) {
        
        let observable = self.searchController.searchBar
            .rx
            .text
            .orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
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
    }

    // MARK: DELEGATE METHODS
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        headerContainerView.isHidden = true
        headerContainerHeightConstraint.constant = 0
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = searchTerm
        headerLabel.text = "Resultados para: \(searchTerm!)"
        headerContainerView.isHidden = false
        headerContainerHeightConstraint.constant = 60
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTerm = searchBar.text
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge + 20 >= scrollView.contentSize.height) {
            homeViewModel.loadMoreMovies()
        }
    }
}

