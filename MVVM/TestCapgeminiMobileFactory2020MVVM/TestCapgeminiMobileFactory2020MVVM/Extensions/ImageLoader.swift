//
//  ImageLoader.swift
//  TestCapgeminiMobileFactory2020MVVM
//
//  Created by Koussaïla Ben Mamar on 09/02/2023.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    // Téléchargement asynchrone de l'image
    // Avec Kingfisher, c'est asynchrone, rapide et efficace. Le cache est géré automatiquement.
    func loadImage(with url: String) {
        let defaultImage = UIImage(systemName: "swift")
        
        guard !url.isEmpty, let imageURL = URL(string: url) else {
            // print("-> ERREUR: URL de l'image indisponible")
            self.image = defaultImage
            return
        }
        
        let resource = ImageResource(downloadURL: imageURL)
        self.kf.indicatorType = .activity // Indicateur pendant le téléchargement
        self.kf.setImage(with: resource, placeholder: defaultImage, options: [.transition(.fade(0.5))])
    }
    
    // Indispenable pour optimiser les performances lors du scroll d'un TableView
    func cancelDownloadTask() {
        self.kf.cancelDownloadTask()
        self.image = nil
    }}
