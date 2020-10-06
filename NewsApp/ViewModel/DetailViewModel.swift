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
    
    init(article: Article) {
        self.article = article
    }
}
