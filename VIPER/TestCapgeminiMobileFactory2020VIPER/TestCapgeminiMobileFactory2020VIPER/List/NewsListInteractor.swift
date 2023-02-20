//
//  NewsListInteractor.swift
//  TestCapgeminiMobileFactory2020VIPER
//
//  Created by Koussaïla Ben Mamar on 16/02/2023.
//

import Foundation

final class NewsListInteractor {
    // Référence avec la présentation, attention à la rétention de cycle (memory leak)
    weak var presenter: NewsListInteractorOutput?
    private var apiService: NewsAPIService?
    
    // Interactor -> Presenter
    init(presenter: NewsListInteractorOutput? = nil, apiService: NewsAPIService) {
        self.presenter = presenter
        self.apiService = apiService
    }
    
    private func handleResult(with result: Result<ArticleOutput, NewsAPIError>) {
        switch result {
            case .success(let output):
                print("\(output.totalResults ?? 0) articles récupérés")
                
                guard let data = output.articles else {
                    print("ERREUR")
                    presenter?.didFetchErrorOccured(with: NewsAPIError.decodeError.rawValue)
                    return
                }
                
                presenter?.didFetchData(viewModels: parseViewModels(with: data))
                
            case .failure(let error):
                presenter?.didFetchErrorOccured(with: error.rawValue)
        }
    }
    
    // Mise en place des vue modèles pour chaque cellule du TableView
    private func parseViewModels(with articles: [Article]) -> [ArticleViewModel] {
        var viewModels = [ArticleViewModel]()
        articles.forEach { viewModels.append(ArticleViewModel(article: $0)) }
        print("Vues modèles d'articles prêts")
        
        return viewModels
    }
}

// Presenter -> Interactor
extension NewsListInteractor: NewsListInteractorInput {
    func fetchNews() {
        print("Call API depuis l'interactor (entrée)")
        apiService?.fetchNews { [weak self] result in
            self?.handleResult(with: result)
        }
    }
    
    func fetchNewsWithSearch(query: String) {
        print("Call API (recherche) depuis l'interactor (entrée)")
        apiService?.searchNews(query: query) { [weak self] result in
            self?.handleResult(with: result)
        }
    }
}
