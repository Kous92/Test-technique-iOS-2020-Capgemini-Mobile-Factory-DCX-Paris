//
//  NewsListProtocols.swift
//  TestCapgeminiMobileFactory2020CleanSwift
//
//  Created by Koussaïla Ben Mamar on 19/02/2023.
//

import Foundation

// Presenter -> View
protocol NewsListDisplayLogic: AnyObject {
    func updateNewsList(with viewModel: NewsList.ViewModel)
    func displayErrorMessage(with viewModel: NewsList.ViewModel.Error)
}

// View -> Interactor
protocol NewsListBusinessLogic: AnyObject {
    func fetchNews(request: NewsList.NewsInit.Request)
    func searchNews(request: NewsList.NewsSearch.Request)
}

// Interactor -> Presenter
protocol NewsListPresentationLogic: AnyObject {
    func presentArticles(response: NewsList.Response)
}

// View -> Router
protocol NewsListRoutingLogic: AnyObject {
    func showDetailView(at indexPath: IndexPath)
}

protocol NewsListDataPassing {
    var dataStore: NewsListDataStore? { get }
}

// Depuis l'Interactor, les données seront stockées. Le routeur récupèrera la donnée souhaitée pour la faire passer à une autre vue par l'intermédiaire d'un autre DataStore.
protocol NewsListDataStore: AnyObject {
    var articles: [Article] { get }
}
