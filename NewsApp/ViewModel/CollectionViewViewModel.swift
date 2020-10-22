//
//  CollectionViewViewModel.swift
//  NewsApp
//
//  Created by user on 06/10/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import UIKit
import CoreData

final class CollectionViewViewModel: CollectionViewViewModelType {
    
    private var selectedIndexPath: IndexPath?
    private var articles = [Article]()
    
    func fetchArticles(completionHandler: @escaping() -> ()) {
        NetworkManagerImp.getTopHeadlines {[weak self] topHeadlinesResponse, error in
            
            if error != nil {
                DispatchQueue.main.async {
                    print(error?.localizedDescription ?? "error")
                    ErrorMessage.showErrorMessage("Нет соеденения с интернетом, будут отображены новости полученные ранее")
                    self?.articles = CollectionViewViewModel.getArticlesFromCD()
                }
                completionHandler()
                return
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
    
    private static func getArticlesFromCD() -> [Article] {
        var articles = [Article]()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<ArticleModel> = ArticleModel.fetchRequest()
            
            if let objects = try? context.fetch(fetchRequest) {
                for articleModel in objects {
                    let source = Source(id: nil, name: articleModel.source!)
                    let article = Article(
                        source: source,
                        author: articleModel.author,
                        title: articleModel.title!,
                        articleDescription: articleModel.articleDescription,
                        url: articleModel.url!,
                        urlToImage: articleModel.urlToImage,
                        publishedAt: articleModel.publishedAt!,
                        content: articleModel.content,
                        imageData: articleModel.imageData,
                        offLine: true
                    )
                    articles.append(article)
                }
            }
            
        }
        return articles
    }
}
