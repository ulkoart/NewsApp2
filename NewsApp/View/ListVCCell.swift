//
//  CVCell.swift
//  NewsApp
//
//  Created by user on 05/10/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import UIKit

class ListVCCell: UICollectionViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet weak var sourseLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    private var imageLoadTask: URLSessionTask?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageLoadTask?.cancel()
    }
    
    func setup(with article: Article) {
        titleLabel.text = article.title
        sourseLabel.text = article.source.name
        
        imageView.image = UIImage(named: "icon-placeholder")
        
        guard let imageUrl = URL(string: article.urlToImage) else { return }
        imageLoadTask = URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        imageLoadTask?.resume()
        self.layer.cornerRadius = 5
    }
}
