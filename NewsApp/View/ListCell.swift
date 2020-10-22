//
//  CVCell.swift
//  NewsApp
//
//  Created by user on 05/10/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import UIKit

class ListCell: UICollectionViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var sourseLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    private var imageLoadTask: URLSessionTask?
    
    weak var viewModel: CollectionViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            setup(title: viewModel.title, sourse: viewModel.sourse, urlToImage: viewModel.urlToImage, imageData: viewModel.imageData)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageLoadTask?.cancel()
    }
    
    private func setup(title: String, sourse: String, urlToImage: String?, imageData: Data?) {
        self.layer.cornerRadius = 5
        titleLabel.text = title
        sourseLabel.text = sourse
        imageView.image = UIImage(named: "icon-placeholder")
        
        if let imageData = imageData {
            let image = UIImage(data: imageData)
            imageView.image = image
        } else {
            guard
                let urlToImage = urlToImage,
                let imageUrl = URL(string: urlToImage) else { return }
            
            imageLoadTask = URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            imageLoadTask?.resume()
        }
        
        
    }
}
