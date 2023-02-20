//
//  NewsDetailRouter.swift
//  TestCapgeminiMobileFactory2020VIPER
//
//  Created by Koussaïla Ben Mamar on 16/02/2023.
//

import Foundation
import UIKit

final class NewsDetailRouter {
    static func createNewsDetailModule(with viewModel: ArticleViewModel) -> NewsDetailViewController {
        guard let newsDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as? NewsDetailViewController else {
            fatalError("La vue détail n'est pas disponible !")
        }
        
        newsDetailViewController.configure(with: viewModel)
        return newsDetailViewController
    }
}
