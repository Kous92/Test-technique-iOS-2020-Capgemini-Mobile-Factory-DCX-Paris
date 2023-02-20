//
//  NewsListRouter.swift
//  TestCapgeminiMobileFactory2020CleanSwift
//
//  Created by Koussaïla Ben Mamar on 19/02/2023.
//

import Foundation
import UIKit

final class NewsListRouter: NewsListRoutingLogic, NewsListDataPassing {
    weak var view: NewsListViewController?
    var dataStore: NewsListDataStore?
    
    func showDetailView(at indexPath: IndexPath) {
        print("Navigation vers la vue détail à l'index \(indexPath.row)")
        guard let newsDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as? NewsDetailViewController,
              let dataStore,
              var detailDataStore = newsDetailViewController.router?.dataStore,
              let newsListViewController = view
        else {
            fatalError("La vue détail n'est pas disponible !")
        }
        
        passDataToArticleDetailView(source: dataStore, destination: &detailDataStore, at: indexPath)
        navigateToArticleDetailView(source: newsListViewController, destination: newsDetailViewController)
    }
    
    // Navigation
    func navigateToArticleDetailView(source: NewsListViewController, destination: NewsDetailViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func passDataToArticleDetailView(source: NewsListDataStore, destination: inout NewsDetailDataStore, at indexPath: IndexPath) {
        destination.article = dataStore?.articles[indexPath.row]
    }
}
