//
//  NewsListViewController.swift
//  TestCapgeminiMobileFactory2020MVVM
//
//  Created by Koussaïla Ben Mamar on 08/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

class NewsListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    /* Partie RxSwift
    - DisposeBag: Utilisé pour éviter les memory leaks, elle stocke les Disposables de chaque abonnement. Cela facilite la gestion des abonnements
     */
    private let disposeBag = DisposeBag()
    private let viewModel = NewsListViewModel(apiService: NewsAPINetworkService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
        viewModel.fetchNews()
    }
    
    // Data binding de l'architecture MVVM avec RxSwift
    private func setBindings() {
        // Recherche réactive
        searchBar.rx.text
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .subscribe { [weak self] query in
                self?.viewModel.searchNews(with: query)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] _ in
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        // Les cellules une fois les données récupérées. L'actualisation est automatique et asynchrone.
        viewModel.articles.bind(to: tableView.rx.items(cellIdentifier: "newsCell", cellType: NewsListTableViewCell.self)) { (row, element, cell) in
            cell.configure(with: element)
        }
        .disposed(by: disposeBag)
        
        // La sélection d'un cellule d'un TableView
        tableView.rx.modelSelected(ArticleViewModel.self)
            .subscribe { [weak self] articleViewModel in
                self?.openDetailView(with: articleViewModel)
            }
            .disposed(by: disposeBag)
        
        // Affichage des erreurs
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                let alert = UIAlertController(title: "Erreur", message: error.rawValue, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                     print("OK")
                }))

                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func openDetailView(with articleViewModel: ArticleViewModel) {
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "NewsDetailViewController") as? NewsDetailViewController else {
            fatalError("Vue détail indisponible")
        }
        
        detailViewController.configure(with: articleViewModel)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
