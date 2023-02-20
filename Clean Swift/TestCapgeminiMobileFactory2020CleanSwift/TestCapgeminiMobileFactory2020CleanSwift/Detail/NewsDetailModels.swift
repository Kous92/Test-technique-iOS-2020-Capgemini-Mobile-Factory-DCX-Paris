//
//  NewsDetailModels.swift
//  TestCapgeminiMobileFactory2020CleanSwift
//
//  Created by Koussaïla Ben Mamar on 19/02/2023.
//

import Foundation

enum NewsDetail {
    enum ArticleDetails {
        struct Request {
        }
        
        struct Response {
            var article: Article
        }
        
        struct ViewModel {
            let source: String
            let author: String
            let title: String
            let description: String
            let urlToImage: String
            let publishedAt: String
            let content: String
            
            init(article: Article) {
                self.source = article.source?.name ?? "Source inconnue"
                self.author = article.author ?? "Auteur inconnu"
                self.title = article.title ?? "Titre indisponible"
                self.description = article.description ?? "Aucune description"
                self.urlToImage = article.urlToImage ?? ""
                self.publishedAt = article.publishedAt?.stringToDateFormat() ?? "Date de publication inconnue"
                self.content = article.content ?? "Contenu indisponible"
            }
        }
    }
}
