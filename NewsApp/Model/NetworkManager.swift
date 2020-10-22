//
//  NetworkManager.swift
//  NewsApp
//
//  Created by user on 05/10/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import UIKit
import CoreData

protocol NetworkManager {
    typealias TopHeadlinesCompletion = (TopHeadlinesResponse?, Error?) -> Void
    static func getTopHeadlines(completionHandler: @escaping TopHeadlinesCompletion)
}

final class NetworkManagerImp: NetworkManager {
    
    private enum Endpoints {
        private static let baseURL = "https://newsapi.org/v2/"
        private static let apiKey = "928161ee44754218bf713fd797f17ea7"
        
        case topHeadlines
        
        var stringValue: String {
            switch self {
            case .topHeadlines: return Endpoints.baseURL + "/top-headlines?country=ru&apiKey=" + Endpoints.apiKey
            }
        }
    }
    
    static func getTopHeadlines(completionHandler: @escaping TopHeadlinesCompletion) {
        guard let url = URL(string: Endpoints.topHeadlines.stringValue) else { return }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let topHeadlinesResponse = try decoder.decode(TopHeadlinesResponse.self, from: data)
                let articles = topHeadlinesResponse.articles
                
                DispatchQueue.main.async {
                    deleteAll()
                    articles.forEach {
                        let source = Source(id: $0.source.id, name: $0.source.name)
                        print(source)
                        let article = Article(source: source, author: $0.author, title: $0.title, articleDescription: $0.articleDescription, url: $0.url, urlToImage: $0.urlToImage, publishedAt: $0.publishedAt, content: $0.content, imageData: nil, offLine: false)
                        save(with: article)
                    }
                }
                
                completionHandler(topHeadlinesResponse, nil)
            } catch let error {
                print(error.localizedDescription)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
}

extension NetworkManagerImp {
    private static func save(with article: Article) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "ArticleModel", in: context) else { return }
            
            let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
            newValue.setValue(article.source.name, forKey: "source")
            newValue.setValue(article.author, forKey: "author")
            newValue.setValue(article.title, forKey: "title")
            newValue.setValue(article.articleDescription, forKey: "articleDescription")
            newValue.setValue(article.url, forKey: "url")
            newValue.setValue(article.urlToImage, forKey: "urlToImage")
            newValue.setValue(article.publishedAt, forKey: "publishedAt")
            newValue.setValue(article.content, forKey: "content")

            
            if let urlToImage = article.urlToImage, let imageUrl = URL(string: urlToImage) {
                let imageLoadTask = URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                    guard let data = data else { return }
                    newValue.setValue(data, forKey: "imageData")
                }
                imageLoadTask.resume()
            }
            
            do {
                try context.save()
                print("Saved \(article.title)")
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    private static func deleteAll() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<ArticleModel> = ArticleModel.fetchRequest()
            
            if let objects = try? context.fetch(fetchRequest) {
                for object in objects {
                    context.delete(object)
                }
            }
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
