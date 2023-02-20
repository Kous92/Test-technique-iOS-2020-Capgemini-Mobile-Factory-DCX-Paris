//
//  NewsListTableViewCell.swift
//  TestCapgeminiMobileFactory2020MVP
//
//  Created by Koussaïla Ben Mamar on 09/02/2023.
//

import UIKit

final class NewsListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDescription: UILabel!
    @IBOutlet weak var imageCellView: UIImageView!
    
    func configure(with viewModel: ArticleViewModel) {
        setViews()
        titleLabel.text = viewModel.title
        titleDescription.text = viewModel.description
        imageCellView.loadImage(with: viewModel.urlToImage)
    }
    
    private func setViews() {
        imageCellView.image = nil
        imageCellView.layer.cornerRadius = 8
        
        // Ombre sur le texte, pour une meilleure lisibilité
        titleLabel.layer.shadowOpacity = 0.8
        titleLabel.layer.shadowRadius = 5
        titleLabel.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCellView.cancelDownloadTask()
    }
}
