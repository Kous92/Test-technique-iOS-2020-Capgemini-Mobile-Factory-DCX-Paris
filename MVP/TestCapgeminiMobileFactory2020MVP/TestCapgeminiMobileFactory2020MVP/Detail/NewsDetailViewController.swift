//
//  NewsDetailViewController.swift
//  TestCapgeminiMobileFactory2020MVP
//
//  Created by Koussaïla Ben Mamar on 09/02/2023.
//

import UIKit

final class NewsDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    private var viewModel: ArticleViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    func configure(with viewModel: ArticleViewModel) {
        self.viewModel = viewModel
    }
    
    private func setViews() {
        // Ombre sur le texte, pour une meilleure lisibilité
        titleLabel.layer.shadowOpacity = 0.8
        titleLabel.layer.shadowRadius = 5
        titleLabel.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        publishDateLabel.layer.shadowOpacity = 0.8
        publishDateLabel.layer.shadowRadius = 5
        publishDateLabel.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        // Le contenu depuis la vue modèle
        titleLabel.text = viewModel?.title ?? "Titre indisponible"
        publishDateLabel.text = viewModel?.publishedAt.stringToDateFormat() ?? ""
        authorLabel.text = viewModel?.author ?? "Auteur inconnu"
        sourceLabel.text = viewModel?.source ?? "Source inconnue"
        contentLabel.text = viewModel?.content ?? "Contenu indisponible";
        articleImageView.loadImage(with: viewModel?.urlToImage ?? "")
    }
}
