//
//  CollectionViewViewModel.swift
//  NewsApp
//
//  Created by user on 06/10/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import UIKit

final class CollectionViewViewModel: CollectionViewViewModelType {
    
    private var selectedIndexPath: IndexPath?
    private var articles = [Article]()
    
    func fetchArticles(completionHandler: @escaping() -> ()) {
        NetworkManagerImp.getTopHeadlines {[weak self] topHeadlinesResponse, error in
            
            if error != nil {
                DispatchQueue.main.async {
                    ErrorMessage.showErrorMessage(error?.localizedDescription ?? "Error :-(")
                }
            }
            
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
    
    func viewModelForSelectedRow() -> DetailViewModelType? {
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        return DetailViewModel(article: articles[selectedIndexPath.row])
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
}
