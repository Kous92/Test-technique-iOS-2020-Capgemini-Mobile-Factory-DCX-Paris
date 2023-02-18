//
//  NewsDetailViewController.swift
//  TestCapgeminiMobileFactory2020MVC
//
//  Created by Koussaïla Ben Mamar on 07/02/2023.
//

import UIKit
import Kingfisher

final class NewsDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    private var article: Article?
    private let defaultImage = UIImage(systemName: "swift")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = article?.title ?? "Titre indisponible"
        publishDateLabel.text = article?.publishedAt?.stringToDateFormat()
        authorLabel.text = article?.author ?? "Auteur inconnu"
        sourceLabel.text = article?.source?.name ?? "Source inconnue"
        contentLabel.text = article?.content ?? "Contenu indisponible"
        articleImageView.loadImage(with: article?.urlToImage ?? "")
    }
    
    func configure(with article: Article) {
        self.article = article
    }
}
