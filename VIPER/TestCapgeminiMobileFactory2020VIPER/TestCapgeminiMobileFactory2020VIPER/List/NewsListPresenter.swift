//
//  NewsListPresenter.swift
//  TestCapgeminiMobileFactory2020VIPER
//
//  Created by Koussaïla Ben Mamar on 16/02/2023.
//

import Foundation
import UIKit

final class NewsListPresenter {
    // Référence circulaire entre le ViewController et le Presenter, attention à la rétention de cycle (memory leak)
    private weak var view: NewsListViewDelegate?
    private var interactor: NewsListInteractorInput?
    private var router: NewsListRouterProtocol?
    
    init(router: NewsListRouterProtocol) {
        self.router = router
    }
    
    func setInteractor(interactor: NewsListInteractorInput) {
        self.interactor = interactor
    }
}

extension NewsListPresenter: NewsListPresenterDelegate {
    func viewDidLoad(with view: NewsListViewDelegate) {
        print("Vue initialisée, lancement de la récupération de données avec l'interacteur.")
        self.view = view
        
        interactor?.fetchNews()
    }
    
    func searchNews(with query: String) {
        print("Lancement de la recherche d'articles avec l'interacteur. Sujet: \(query)")
        interactor?.fetchNewsWithSearch(query: query)
    }
    
    func showNewsDetail(with viewModel: ArticleViewModel, navigationController: UINavigationController?) {
        print("Navigation de la liste à la vue détail")
        router?.pushToDetailView(with: viewModel, navigationController: navigationController)
    }
}

extension NewsListPresenter: NewsListInteractorOutput {
    func didFetchData(viewModels: [ArticleViewModel]) {
        print("Vue prête à l'actualisation avec \(viewModels.count) entités.")
        view?.didLoadData(with: viewModels)
    }
    
    func didFetchErrorOccured(with errorMessage: String) {
        print("Une erreur est survenue: \(errorMessage)")
        view?.didErrorOccured(with: errorMessage)
    }
}
