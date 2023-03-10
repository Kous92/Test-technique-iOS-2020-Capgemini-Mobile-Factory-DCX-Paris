//
//  NewsAPIError.swift
//  TestCapgeminiMobileFactory2020MVC
//
//  Created by Koussaïla Ben Mamar on 07/02/2023.
//

import Foundation

enum NewsAPIError: String, Error {
    case parametersMissing = "Erreur 400: Paramètres manquants dans la requête."
    case invalidApiKey = "Erreur 401: La clé d'API fournie est invalide ou inexistante."
    case notFound = "Erreur 404: Aucun contenu disponible."
    case tooManyRequests = "Erreur 429: Trop de requêtes ont été effectuées dans un laps de temps. Veuillez réessayer ultérieurement."
    case serverError = "Erreur 500: Erreur serveur."
    case apiError = "Une erreur est survenue."
    case invalidURL = "Erreur: URL invalide."
    case networkError = "Une erreur est survenue, pas de connexion Internet."
    case decodeError = "Une erreur est survenue au décodage des données téléchargées."
    case downloadError = "Une erreur est survenue au téléchargement des données."
    case unknown = "Erreur inconnue."
}
