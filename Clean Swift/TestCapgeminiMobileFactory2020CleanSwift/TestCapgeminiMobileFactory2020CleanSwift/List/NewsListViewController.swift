//
//  NewsListViewController.swift
//  TestCapgeminiMobileFactory2020CleanSwift
//
//  Created by Koussaïla Ben Mamar on 19/02/2023.
//

import UIKit
import RxCocoa
import RxSwift

final class NewsListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    /* Partie RxSwift:
    - PublishSubject: un sujet (Subject) faisant office d'émetteur (Observer) et de récepteur (Observable, abonné). Avec .onNext(), on émet une valeur. Particularité de ce type de sujet: démarre sans valeur et émet seulement des nouveaux éléments aux abonnés.
       -> La partie qui va s'abonner au sujet recevra la valeur avec .subscribe(onNext: { value in })
    - DisposeBag: Utilisé pour éviter les memory leaks, elle stocke les Disposables de chaque abonnement. Cela facilite la gestion des abonnements.
    */
    private let disposeBag = DisposeBag()
    private let articles = PublishSubject<[NewsList.ViewModel.NewsViewModel]>()
    private let error = PublishSubject<NewsList.ViewModel.Error>()
    
    private var interactor: NewsListBusinessLogic?
    private var router: (NewsListRoutingLogic & NewsListDataPassing)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        print("Cycle Clean Swift (VIP):")
        print("1) View -> Interactor: Demande de news")
        interactor?.fetchNews(request: NewsList.NewsInit.Request())
    }
    
    // Mise en place des composants de Clean Swift
    private func setup() {
        setBindings()
        let interactor = NewsListInteractor(with: NewsAPINetworkService())
        let presenter = NewsListPresenter()
        let router = NewsListRouter()
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.view = self
        router.view = self
        router.dataStore = interactor
    }
    
    private func setBindings() {
        // Recherche réactive
        searchBar.rx.text
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .subscribe { [weak self] query in
                print("1) View -> Interactor: Demande de news (recherche avec \(query))")
                self?.interactor?.searchNews(request: NewsList.NewsSearch.Request(searchQuery: query))
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
        
        tableView.rx.itemSelected
            .map { indexPath in
                return indexPath
            }
            .subscribe { [weak self] indexPath in
                print("Cellule sélectionnée: \(indexPath)")
                self?.router?.showDetailView(at: indexPath)
            }
            .disposed(by: disposeBag)
        
        // Affichage des erreurs
        error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                let alert = UIAlertController(title: "Erreur", message: error.message, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                     print("OK")
                }))

                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

// NewsListPresenter 
extension NewsListViewController: NewsListDisplayLogic {
    func updateNewsList(with viewModel: NewsList.ViewModel) {
        print("7) Vue actualisée avec les données de vues modèles pour la TableView.")
        articles.onNext(viewModel.cellViewModels)
    }
    
    func displayErrorMessage(with errorViewModel: NewsList.ViewModel.Error) {
        print("7) Vue actualisée avec une erreur.")
        error.onNext(errorViewModel)
    }
}
