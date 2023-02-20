//
//  ArticleViewModel.swift
//  TestCapgeminiMobileFactory2020MVVM
//
//  Created by Koussaïla Ben Mamar on 09/02/2023.
//

import Foundation

final class ArticleViewModel {
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
        self.publishedAt = article.publishedAt ?? "Date inconnue"
        self.content = article.content ?? "Contenu indisponible"
    }
}
