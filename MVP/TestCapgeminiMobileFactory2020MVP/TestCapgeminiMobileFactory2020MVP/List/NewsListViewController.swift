//
//  ViewController.swift
//  TestCapgeminiMobileFactory2020MVP
//
//  Created by Koussaïla Ben Mamar on 08/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class NewsListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private let articles = PublishSubject<[ArticleViewModel]>()
    private let error = PublishSubject<String>()
    
    // Référence circulaire. Forte de la vue avec le présentateur, faible du présentateur vers la vue.
    private lazy var presenter = NewsListPresenter(apiService: NewsAPINetworkService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
        presenter.setViewDelegate(delegate: self)
        presenter.fetchNews()
    }
    
    private func setBindings() {
        // Recherche réactive
        searchBar.rx.text
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .subscribe { [weak self] query in
                self?.presenter.searchNews(with: query)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] _ in
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        // Les cellules une fois les données récupérées. L'actualisation est automatique et asynchrone.
        articles.bind(to: tableView.rx.items(cellIdentifier: "newsCell", cellType: NewsListTableViewCell.self)) { (row, element, cell) in
            cell.configure(with: element)
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ArticleViewModel.self)
            .subscribe { [weak self] article in
                self?.openDetailView(with: article)
            }
            .disposed(by: disposeBag)
        
        // Affichage des erreurs
        error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                let alert = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
                
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

extension NewsListViewController: NewsListViewDelegate {
    func didLoadData(with viewModels: [ArticleViewModel]) {
        articles.onNext(viewModels)
    }
    
    func didErrorOccured(with errorMessage: String) {
        error.onNext(errorMessage)
    }
}
