//
//  NewsListWorker.swift
//  TestCapgeminiMobileFactory2020CleanSwift
//
//  Created by Koussaïla Ben Mamar on 19/02/2023.
//

import Foundation

final class NewsListWorker {
    private var apiService: NewsAPIService?
    
    init(apiService: NewsAPIService) {
        self.apiService = apiService
    }
    
    func fetchNews(completion: @escaping (_ response: NewsList.Response) -> ()) {
        print("3) Worker: Call API.")
        apiService?.fetchNews { [weak self] result in
            if let self {
                completion(self.handleResult(with: result))
            }
        }
    }
    
    func fetchNewsWithSearch(query: String, completion: @escaping (_ response: NewsList.Response) -> ()) {
        print("3) Worker: Call API (recherche).")
        apiService?.searchNews(query: query) { [weak self] result in
            if let self {
                completion(self.handleResult(with: result))
            }
        }
    }
    
    private func handleResult(with result: Result<ArticleOutput, NewsAPIError>) -> NewsList.Response {
        print("4) Worker: Renvoi de la réponse à l'Interactor.")
        switch result {
            case .success(let output):
                // print("\(output.totalResults ?? 0) articles récupérés")
                
                guard let data = output.articles else {
                    print("-> 4.1) Échec: pas d'articles récupérés lors du décodage")
                    return NewsList.Response(result: .failure(NewsAPIError.decodeError))
                }
                
                print("-> 4.1) Succès: \(data.count) articles récupérés.")
                return NewsList.Response(result: .success(data))
                
            case .failure(let error):
                print("-> 4.1) Échec: une erreur est survenue.")
                return NewsList.Response(result: .failure(error))
        }
    }
}
