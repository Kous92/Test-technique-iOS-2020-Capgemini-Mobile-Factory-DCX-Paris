//
//  NewsDetailPresenter.swift
//  TestCapgeminiMobileFactory2020CleanSwift
//
//  Created by Koussaïla Ben Mamar on 19/02/2023.
//

import Foundation

final class NewsDetailPresenter: NewsDetailPresentationLogic {
    /* Référence vers le ViewController qui l'utilise. Faible car il y a un cycle de références (indirect):
    - ViewController -> Interactor -> Presenter -> ViewController (Cycle VIP, unidirectionnel)
    - Même indirect, risque de memory leak si la vue est détruite.
    */
    weak var view: NewsDetailDisplayLogic?
    
    func presentArticle(response: NewsDetail.ArticleDetails.Response) {
        view?.displayArticle(with: NewsDetail.ArticleDetails.ViewModel(article: response.article))
    }
}
