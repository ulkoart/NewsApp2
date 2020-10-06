//
//  CollectionViewCellViewModel.swift
//  NewsApp
//
//  Created by user on 06/10/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import Foundation

class CollectionViewCellViewModel: CollectionViewCellViewModelType {
    private var article: Article
    
    var title: String {
        return article.title
    }
    var sourse: String {
        return article.source.name
    }
    var urlToImage: String {
        return article.urlToImage
    }
    
    init(article: Article) {
        self.article = article
    }
}
