//
//  NewsAPIService.swift
//  TestCapgeminiMobileFactory2020MVC
//
//  Created by Koussaïla Ben Mamar on 07/02/2023.
//

import Foundation

protocol NewsAPIService {
    func fetchNews(completion: @escaping (Result<ArticleOutput, NewsAPIError>) -> ())
    func searchNews(query: String, completion: @escaping (Result<ArticleOutput, NewsAPIError>) -> ())
}
