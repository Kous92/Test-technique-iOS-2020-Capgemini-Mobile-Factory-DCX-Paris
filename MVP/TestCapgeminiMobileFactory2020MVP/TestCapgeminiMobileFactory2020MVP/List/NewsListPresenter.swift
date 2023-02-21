//
//  NewsListPresenter.swift
//  TestCapgeminiMobileFactory2020MVP
//
//  Created by Koussaïla Ben Mamar on 09/02/2023.
//

import Foundation

protocol NewsListViewDelegate: AnyObject {
    func didLoadData(with viewModels: [ArticleViewModel])
    func didErrorOccured(with errorMessage: String)
}

final class NewsListPresenter {
    private let apiService: NewsAPIService?
    
    // Référence avec la vue, attention à la rétention de cycle (memory leak)
    weak private var delegate: NewsListViewDelegate?
    
    // Grâce à une injection de dépendance par le biais d'un type abstrait, la testabilité sera assurée si on utilise un mock pour simuler les appels d'API REST.
    init(apiService: NewsAPIService) {
        self.apiService = apiService
    }
    
    func setViewDelegate(delegate: NewsListViewDelegate){
        self.delegate = delegate
    }
    
    func fetchNews() {
        print("Call depuis le Presenter")
        apiService?.fetchNews { [weak self] result in
            self?.handleResult(with: result)
        }
    }
    
    func searchNews(with query: String) {
        print("Call search depuis le Presenter")
        apiService?.searchNews(query: query) { [weak self] result in
            self?.handleResult(with: result)
        }
    }
    
    private func handleResult(with result: Result<ArticleOutput, NewsAPIError>) {
        switch result {
            case .success(let output):
                print("\(output.totalResults ?? 0) articles")
                
                guard let data = output.articles else {
                    print("ERREUR")
                    delegate?.didErrorOccured(with: NewsAPIError.decodeError.rawValue)
                    return
                }
                
                delegate?.didLoadData(with: parseViewModels(with: data))
                
            case .failure(let error):
                delegate?.didErrorOccured(with: error.rawValue)
        }
    }
    
    private func parseViewModels(with articles: [Article]) -> [ArticleViewModel] {
        var viewModels = [ArticleViewModel]()
        articles.forEach { viewModels.append(ArticleViewModel(article: $0)) }
        
        return viewModels
    }
}
