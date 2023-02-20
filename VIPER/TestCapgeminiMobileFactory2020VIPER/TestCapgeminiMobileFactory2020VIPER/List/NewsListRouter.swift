//
//  NewsListRouter.swift
//  TestCapgeminiMobileFactory2020VIPER
//
//  Created by Koussaïla Ben Mamar on 16/02/2023.
//

import Foundation
import UIKit

final class NewsListRouter: NewsListRouterProtocol {
    static func createNewsListModule() -> NewsListViewController {
        guard let listViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsListViewController") as? NewsListViewController else {
            fatalError("La vue de départ n'est pas disponible !")
        }
        
        let presenter = NewsListPresenter(router: NewsListRouter())
        let interactor = NewsListInteractor(presenter: presenter, apiService: NewsAPIService())
        presenter.setInteractor(interactor: interactor)
        listViewController.setPresenter(presenter: presenter)
        
        return listViewController
    }
    
    static func createNewsDetailModule(with viewModel: ArticleViewModel) -> UIViewController {
        guard let newsDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as? NewsDetailViewController else {
            fatalError("La vue détail n'est pas disponible !")
        }
        
        newsDetailViewController.configure(with: viewModel)
        return newsDetailViewController
    }
    
    func pushToDetailView(with viewModel: ArticleViewModel, navigationController: UINavigationController?) {
        let detailViewController = NewsDetailRouter.createNewsDetailModule(with: viewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
