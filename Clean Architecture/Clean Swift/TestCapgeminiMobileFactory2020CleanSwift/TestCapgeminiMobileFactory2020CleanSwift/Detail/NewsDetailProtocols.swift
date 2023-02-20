//
//  NewsDetailProtocols.swift
//  TestCapgeminiMobileFactory2020CleanSwift
//
//  Created by Koussaïla Ben Mamar on 19/02/2023.
//

import Foundation

// Presenter -> View
protocol NewsDetailDisplayLogic: AnyObject {
    func displayArticle(with viewModel: NewsDetail.ArticleDetails.ViewModel)
}

// View -> Interactor
protocol NewsDetailBusinessLogic: AnyObject {
    func getPassedArticle(request: NewsDetail.ArticleDetails.Request)
}

// Interactor -> Presenter
protocol NewsDetailPresentationLogic: AnyObject {
    func presentArticle(response: NewsDetail.ArticleDetails.Response)
}

// Depuis l'Interactor, les données seront stockées. Particularité, ce Data Store sera initialisé avec une donnée du routeur provenant d'un autre Data Store
protocol NewsDetailDataStore: AnyObject {
    var article: Article? { get set }
}

// Le routeur n'aura que la réception de données de la vue précédente comme responsabilité
protocol NewsDetailDataPassing {
    var dataStore: NewsDetailDataStore? { get }
}
