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
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let topHeadlinesResponse = try decoder.decode(TopHeadlinesResponse.self, from: data)
                let articles = topHeadlinesResponse.articles
                
                DispatchQueue.main.async {
                    articles.forEach {
                        let source: String = $0.source.name
                        save(value: source)
                    }
                }
                
                completionHandler(topHeadlinesResponse, nil)
            } catch let error {
                print(error)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
}

extension NetworkManagerImp {
    static func save(value: String) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "ArticleModel", in: context) else { return }
            
            let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
            newValue.setValue(value, forKey: "source")
            
            do {
                try context.save()
                print("Saved \(value)")
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
