//
//  ViewController.swift
//  NewsApp
//
//  Created by user on 05/10/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import UIKit

class CollectionVC: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView!
    
    private let reuseIdentifier = "Cell"
    private let refreshControl = UIRefreshControl()
    private var articles = [Article]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadArticles()
    }
    
    private func loadArticles() {
        NetworkManagerImp.getTopHeadlines() {topHeadlinesResponse,error in
            guard let topHeadlinesResponse = topHeadlinesResponse else { return }
            self.articles = topHeadlinesResponse.articles
        }
    }
    
    private func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshArticles(_:)), for: .valueChanged)
    }
    
    @objc private func refreshArticles(_ sender: Any) {
        self.refreshControl.endRefreshing()
    }
}

// MARK: - Collection

extension CollectionVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ListVCCell else {
            fatalError("cell wasn't configured")
        }
        let article = articles[indexPath.row]
        cell.setup(with: article)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }
}

// MARK: - Navigation

extension CollectionVC {
    
}
