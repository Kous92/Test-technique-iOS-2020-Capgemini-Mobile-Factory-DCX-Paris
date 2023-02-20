//
//  NewsListInteractor.swift
//  TestCapgeminiMobileFactory2020CleanSwift
//
//  Created by Koussaïla Ben Mamar on 19/02/2023.
//

import Foundation

class NewsListInteractor: NewsListDataStore {
    var articles: [Article] = []
    
    // Référence vers le Worker pour le call API
    private var worker: NewsListWorker
    
    // Notifier le Presenter avec les méthodes déléguées
    var presenter: NewsListPresentationLogic?
    
    init(with apiService: NewsAPIService) {
        self.worker = NewsListWorker(apiService: apiService)
    }
}

extension NewsListInteractor: NewsListBusinessLogic {
    func fetchNews(request: NewsList.NewsInit.Request) {
        print("2) Interactor: Lancement de l'appel API depuis le Worker.")
        worker.fetchNews { [weak self] response in
            print("5) Interactor -> Presenter: Réponse récupérée, notification du Presenter")
            self?.prepareDataStore(with: response)
            self?.presenter?.presentArticles(response: response)
        }
    }
    
    func searchNews(request: NewsList.NewsSearch.Request) {
        print("2) Interactor: Lancement de l'appel API depuis le Worker.")
        worker.fetchNewsWithSearch(query: request.searchQuery) { [weak self] response in
            print("5) Interactor -> Presenter: Réponse récupérée, notification du Presenter")
            self?.prepareDataStore(with: response)
            self?.presenter?.presentArticles(response: response)
        }
    }
    
    private func prepareDataStore(with response: NewsList.Response) {
        switch response.result {
            case .success(let articles):
                guard let articles else {
                    print("ERREUR DataStore")
                    return
                }
                
                self.articles = articles
                print("-> 5.1) Interactor: Data Store mis à jour pour le routeur.")
            default:
                return
        }
    }
}
