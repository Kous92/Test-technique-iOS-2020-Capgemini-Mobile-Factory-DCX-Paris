//
//  NewsListViewController.swift
//  TestCapgeminiMobileFactory2020VIPER
//
//  Created by Koussaïla Ben Mamar on 11/02/2023.
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

    private var presenter: NewsListPresenterDelegate?
    
    func setPresenter(presenter: NewsListPresenterDelegate) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
        
        let presenter = NewsListPresenter(router: NewsListRouter())
        let interactor = NewsListInteractor(presenter: presenter, apiService: NewsAPIService())
        presenter.setInteractor(interactor: interactor)
        self.presenter = presenter
        self.presenter?.viewDidLoad(with: self)
    }
    
    private func setBindings() {
        // Recherche réactive
        searchBar.rx.text
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .subscribe { [weak self] query in
                self?.presenter?.searchNews(with: query)
            }
            .disposed(by: disposeBag)
        
        // Les cellules une fois les données récupérées. L'actualisation est automatique et asynchrone.
        articles.bind(to: tableView.rx.items(cellIdentifier: "newsCell", cellType: NewsListTableViewCell.self)) { (row, element, cell) in
            cell.configure(with: element)
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ArticleViewModel.self)
            .subscribe { [weak self] article in
                // self?.openDetailView(with: article)
                self?.presenter?.showNewsDetail(with: article, navigationController: self?.navigationController)
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
}

extension NewsListViewController: NewsListViewDelegate {
    func didLoadData(with viewModels: [ArticleViewModel]) {
        print("La liste est actualisée")
        articles.onNext(viewModels)
    }
    
    func didErrorOccured(with errorMessage: String) {
        print("Recherche terminée, la liste est actualisée")
        error.onNext(errorMessage)
    }
}
