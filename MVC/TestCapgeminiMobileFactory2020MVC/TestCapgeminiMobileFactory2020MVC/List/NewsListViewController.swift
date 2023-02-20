//
//  ViewController.swift
//  TestCapgeminiMobileFactory2020MVC
//
//  Created by Koussaïla Ben Mamar on 07/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class NewsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    /* Partie RxSwift:
     - PublishSubject: un sujet (Subject) faisant office d'émetteur (Observer) et de récepteur (Observable, abonné). Avec .onNext(), on émet une valeur. Particularité de ce type de sujet: démarre sans valeur et émet seulement des nouveaux éléments aux abonnés.
       -> La partie qui va s'abonner au sujet recevra la valeur avec .subscribe(onNext: { value in })
     - DisposeBag:
    */
    private let disposeBag = DisposeBag()
    private let articles = PublishSubject<[Article]>()
    private let error = PublishSubject<NewsAPIError>()
    private var apiService = NewsAPIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
        fetchNews()
    }
    
    private func setBindings() {
        // Recherche réactive
        searchBar.rx.text
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .subscribe { query in
                self.searchNews(with: query)
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
        
        tableView.rx.modelSelected(Article.self)
            .subscribe { [weak self] article in
                self?.openDetailView(with: article)
            }
            .disposed(by: disposeBag)
        
        // Affichage des erreurs
        error
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
    
    private func openDetailView(with article: Article) {
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "NewsDetailViewController") as? NewsDetailViewController else {
            fatalError("Vue détail indisponible")
        }
        
        detailViewController.configure(with: article)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// Logique métier (Business logic), pour effectuer les appels d'API REST.
extension NewsListViewController {
    private func fetchNews() {
        apiService.fetchNews { [weak self] result in
            self?.handleResult(with: result)
        }
    }
    
    private func searchNews(with query: String) {
        apiService.searchNews(query: query) { [weak self] result in
            self?.handleResult(with: result)
        }
    }
    
    private func handleResult(with result: Result<ArticleOutput, NewsAPIError>) {
        switch result {
            case .success(let output):
                print("\(output.totalResults ?? 0) articles")
                
                guard let data = output.articles else {
                    print("ERREUR")
                    self.error.onNext(.decodeError)
                    return
                }
                
                articles.onNext(data)
                
            case .failure(let error):
                self.error.onNext(error)
        }
    }
}
