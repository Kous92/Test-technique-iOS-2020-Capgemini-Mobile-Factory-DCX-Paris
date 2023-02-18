//
//  NewsAPIService.swift
//  TestCapgeminiMobileFactory2020MVC
//
//  Created by Koussaïla Ben Mamar on 07/02/2023.
//

import Foundation
import Alamofire

final class NewsAPIService {
    private var apiKey: String = "API_KEY"
    
    func fetchNews(completion: @escaping (Result<ArticleOutput, NewsAPIError>) -> ()) {
        getRequest(endpoint: .initNews(country: "fr"), completion: completion)
    }
    
    func searchNews(query: String, completion: @escaping (Result<ArticleOutput, NewsAPIError>) -> ()) {
        getRequest(endpoint: .searchNews(language: "fr", query: query.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? ""), completion: completion)
    }
    
    private func getRequest<T: Decodable>(endpoint: NewsAPIEndpoint, completion: @escaping (Result<T, NewsAPIError>) -> ()) {
        guard let url = URL(string: endpoint.baseURL + endpoint.path + "&sortBy=publishedAt&apiKey=\(apiKey)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        print("URL appelée: \(url.absoluteString)")
        
        AF.request(url).validate().responseDecodable(of: T.self) { response in
            switch response.result {
            case .success:
                guard let data = response.value else {
                    completion(.failure(.downloadError))
                    return
                }
                
                completion(.success(data))
            case let .failure(error):
                guard let httpResponse = response.response else {
                    print("ERREUR: \(error)")
                    completion(.failure(.networkError))
                    return
                }
                
                switch httpResponse.statusCode {
                case 400:
                    completion(.failure(.parametersMissing))
                case 401:
                    completion(.failure(.invalidApiKey))
                case 404:
                    completion(.failure(.notFound))
                case 429:
                    completion(.failure(.tooManyRequests))
                case 500:
                    completion(.failure(.serverError))
                default:
                    completion(.failure(.unknown))
                }
            }
        }
    }
}