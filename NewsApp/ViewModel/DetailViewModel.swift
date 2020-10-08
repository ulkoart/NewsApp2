//
//  DetailViewModel.swift
//  NewsApp
//
//  Created by user on 06/10/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import Foundation

class DetailViewModel: DetailViewModelType {
    private var article: Article
    
    var title: String {
        return article.title
    }
    
    var description: String? {
        return article.articleDescription
    }
    
    var sourse: String {
        return article.source.name
    }
    
    var url: String {
        return article.url
    }
    
    init(article: Article) {
        self.article = article
    }
}
