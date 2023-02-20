//
//  NewsListPresenter.swift
//  TestCapgeminiMobileFactory2020CleanSwift
//
//  Created by Koussaïla Ben Mamar on 19/02/2023.
//

import Foundation

final class NewsListPresenter {
    /* Référence vers le ViewController qui l'utilise. Faible car il y a un cycle de références (indirect):
    - ViewController -> Interactor -> Presenter -> ViewController (Cycle VIP, unidirectionnel)
    - Même indirect, risque de memory leak si la vue est détruite.
    */
    weak var view: NewsListDisplayLogic?
    
    // Mise en place des vue modèles pour chaque cellule du TableView
    private func parseViewModels(with articles: [Article]) -> [NewsList.ViewModel.NewsViewModel] {
        var viewModels = [NewsList.ViewModel.NewsViewModel]()
        articles.forEach { viewModels.append(NewsList.ViewModel.NewsViewModel(article: $0)) }
        
        return viewModels
    }
}

extension NewsListPresenter: NewsListPresentationLogic {
    func presentArticles(response: NewsList.Response) {
        print("6) Presenter -> View: Notification de la vue pour mise à jour avec la réponse.")
        switch response.result {
            case .success(let articles):
                guard let articles else {
                    print("-> 6.1) Presenter -> View: Notification de la vue d'une erreur.")
                    view?.displayErrorMessage(with: NewsList.ViewModel.Error(message: NewsAPIError.decodeError.rawValue))
                    return
                }
                
                print("-> 6.1) Presenter -> View: Notification de la vue avec les vues modèles.")
                view?.updateNewsList(with: NewsList.ViewModel(cellViewModels: parseViewModels(with: articles)))
            case .failure(let error):
                print("-> 6.1) Presenter -> View: Notification de la vue d'une erreur.")
                view?.displayErrorMessage(with: NewsList.ViewModel.Error(message: error.rawValue))
        }
    }
}
