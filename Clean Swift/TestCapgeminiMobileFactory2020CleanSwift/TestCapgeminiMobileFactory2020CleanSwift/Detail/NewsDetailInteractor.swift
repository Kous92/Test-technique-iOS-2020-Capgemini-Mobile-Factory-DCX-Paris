//
//  NewsDetailInteractor.swift
//  TestCapgeminiMobileFactory2020CleanSwift
//
//  Created by Koussaïla Ben Mamar on 19/02/2023.
//

import Foundation

final class NewsDetailInteractor: NewsDetailDataStore {
    var article: Article?
    
    // Notifier le Presenter avec la méthode déléguée
    var presenter: NewsDetailPresentationLogic?
}

extension NewsDetailInteractor: NewsDetailBusinessLogic {
    func getPassedArticle(request: NewsDetail.ArticleDetails.Request) {
        if let article {
            presenter?.presentArticle(response: NewsDetail.ArticleDetails.Response(article: article))
        }
    }
}
