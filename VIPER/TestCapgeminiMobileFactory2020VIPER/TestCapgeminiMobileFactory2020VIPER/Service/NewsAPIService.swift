//
//  NewsAPIService.swift
//  TestCapgeminiMobileFactory2020VIPER
//
//  Created by Koussaïla Ben Mamar on 19/02/2023.
//

import Foundation

protocol NewsAPIService {
    func fetchNews(completion: @escaping (Result<ArticleOutput, NewsAPIError>) -> ())
    func searchNews(query: String, completion: @escaping (Result<ArticleOutput, NewsAPIError>) -> ())
}
