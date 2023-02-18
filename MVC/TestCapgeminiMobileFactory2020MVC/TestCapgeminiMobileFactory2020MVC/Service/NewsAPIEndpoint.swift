//
//  NewsAPIEndpoint.swift
//  TestCapgeminiMobileFactory2020MVC
//
//  Created by Koussaïla Ben Mamar on 07/02/2023.
//

import Foundation

enum NewsAPIEndpoint {
    case initNews(country: String)
    case searchNews(language: String, query: String)
    
    var baseURL: String {
        return "https://newsapi.org/v2/"
    }
    
    var path: String {
        switch self {
        case .initNews(let country):
            return "top-headlines?country=\(country)"
        case .searchNews(let language, let query):
            return "everything?language=\(language)&q=\(query)&sortBy=publishedAt"
        }
    }
}
