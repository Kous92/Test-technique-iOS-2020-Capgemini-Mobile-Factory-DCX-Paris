//
//  NewsListProtocols.swift
//  TestCapgeminiMobileFactory2020VIPER
//
//  Created by Koussaïla Ben Mamar on 16/02/2023.
//

import Foundation
import UIKit

// En entrée pour recevoir les interactions de la vue
protocol NewsListPresenterDelegate: AnyObject {
    func viewDidLoad(with view: NewsListViewDelegate)
    func searchNews(with query: String)
    func showNewsDetail(with viewModel: ArticleViewModel, navigationController: UINavigationController?)
}

// En sortie pour recevoir les instructions du Presenter et actualiser la vue
protocol NewsListViewDelegate: AnyObject {
    func didLoadData(with viewModels: [ArticleViewModel])
    func didErrorOccured(with errorMessage: String)
}

// En entrée pour recevoir les instructions du Presenter
protocol NewsListInteractorInput: AnyObject {
    func fetchNews()
    func fetchNewsWithSearch(query: String)
}

// En sortie pour renvoyer les données au Presenter
protocol NewsListInteractorOutput: AnyObject {
    func didFetchData(viewModels: [ArticleViewModel])
    func didFetchErrorOccured(with errorMessage: String)
}

protocol NewsListRouterProtocol: AnyObject {
    static func createNewsListModule() -> NewsListViewController
    func pushToDetailView(with viewModel: ArticleViewModel, navigationController: UINavigationController?)
}
