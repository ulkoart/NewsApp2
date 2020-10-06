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
    private var viewModel: CollectionViewViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshArticles(_:)), for: .valueChanged)
        
        viewModel = CollectionViewViewModel()
        viewModel?.fetchArticles {
            [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc private func refreshArticles(_ sender: Any) {
        self.refreshControl.endRefreshing()
    }
}

// MARK: - Collection

extension CollectionVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ListCell,
            let viewModel = viewModel else { fatalError("cell wasn't configured")}

        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
}

// MARK: - Navigation

extension CollectionVC {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detail = storyboard?.instantiateViewController(withIdentifier: "ShowDetail") as? DetailVC else {
            fatalError("DetailVC wasn't configured")
        }
        navigationController?.pushViewController(detail, animated: true)
    }
}
