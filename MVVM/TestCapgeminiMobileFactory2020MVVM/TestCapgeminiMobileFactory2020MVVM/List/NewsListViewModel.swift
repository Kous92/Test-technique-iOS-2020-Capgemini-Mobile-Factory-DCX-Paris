//
//  NewsListViewModel.swift
//  TestCapgeminiMobileFactory2020MVVM
//
//  Created by Koussaïla Ben Mamar on 09/02/2023.
//

import Foundation
import RxSwift

final class NewsListViewModel {
    /* Partie RxSwift:
     - PublishSubject: un sujet (Subject) faisant office d'émetteur (Observer) et de récepteur (Observable, abonné). Avec .onNext(), on émet une valeur. Particularité de ce type de sujet: démarre sans valeur et émet seulement des nouveaux éléments aux abonnés.
       -> La partie qui va s'abonner au sujet recevra la valeur avec .subscribe(onNext: { value in })
     - DisposeBag:
    */
    private let disposeBag = DisposeBag()
    let articles = PublishSubject<[ArticleViewModel]>()
    let error = PublishSubject<NewsAPIError>()
    
    private let apiService: NewsAPIService?
    
    init(apiService: NewsAPIService) {
        self.apiService = apiService
    }
    
    func fetchNews() {
        print("Call depuis le viewModel")
        apiService?.fetchNews { [weak self] result in
            self?.handleResult(with: result)
        }
    }
    
    func searchNews(with query: String) {
        print("Call search depuis le viewModel")
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
                    self.error.onNext(.decodeError)
                    return
                }
                
                articles.onNext(parseViewModels(with: data))
                
            case .failure(let error):
                self.error.onNext(error)
        }
    }
    
    private func parseViewModels(with articles: [Article]) -> [ArticleViewModel] {
        var viewModels = [ArticleViewModel]()
        articles.forEach { viewModels.append(ArticleViewModel(article: $0)) }
        
        return viewModels
    }
}
