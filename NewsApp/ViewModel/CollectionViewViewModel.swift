//
//  CollectionViewViewModel.swift
//  NewsApp
//
//  Created by user on 06/10/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import Foundation

final class CollectionViewViewModel: CollectionViewViewModelType {
    
    private var articles = [Article]()
    
    func fetchArticles(completionHandler: @escaping() -> ()) {
        NetworkManagerImp.getTopHeadlines {[weak self] topHeadlinesResponse,error in           
            guard let topHeadlinesResponse = topHeadlinesResponse else { return }
            self?.articles = topHeadlinesResponse.articles
            completionHandler()
        }
    }
    
    func numberOfRows() -> Int {
        return articles.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> CollectionViewCellViewModelType? {
        let article = articles[indexPath.row]
        return CollectionViewCellViewModel(article: article)
    }
}
