//
//  NewsListModels.swift
//  TestCapgeminiMobileFactory2020CleanSwift
//
//  Created by Koussaïla Ben Mamar on 19/02/2023.
//

import Foundation

/* Le modèle de données pour le use case de la liste d'article lors de l'initialisation ou d'une recherche
En Clean Swift, il y a 3 types de structures pour chaque use case (cas d'utilisation)
1) Une structure de requête (Request)
2) Une structure de réponse (Response)
3) Une structure de vue modèle pour la présentation à la vue, il peut y en avoir plusieurs comme un contenant les données affichées lorsqu'une requête a réussi, et un contenant un message d'erreur lors d'un échec.
 // Lorsqu'on effectue une requête, on y envoie un objet Request avec ou non des paramètres
*/
enum NewsList {
    enum NewsInit {
        struct Request {
        }
    }
    
    enum NewsSearch {
        struct Request {
            let searchQuery: String
        }
    }
    
    struct Response {
        var result: Result<[Article]?, NewsAPIError>
    }
    
    struct ViewModel {
        struct NewsViewModel {
            let title: String
            let description: String
            let urlToImage: String
            
            init(article: Article) {
                self.title = article.title ?? "Titre indisponible"
                self.description = article.description ?? "Aucune description"
                self.urlToImage = article.urlToImage ?? ""
            }
        }
        
        var cellViewModels: [NewsViewModel]
        
        struct Error {
            let message: String
        }
    }
}
