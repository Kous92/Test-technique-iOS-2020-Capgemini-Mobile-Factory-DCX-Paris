//
//  Article.swift
//  TestCapgeminiMobileFactory2020MVC
//
//  Created by Koussaïla Ben Mamar on 07/02/2023.
//

import Foundation

// MARK: - Response
struct ArticleOutput: Decodable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

// MARK: - Article
struct Article: Decodable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

// MARK: - Source
struct Source: Decodable {
    let name: String?
}
