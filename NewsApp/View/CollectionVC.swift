//
//  ViewController.swift
//  NewsApp
//
//  Created by user on 05/10/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import UIKit
import CoreData

class CollectionVC: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private let reuseIdentifier = "Cell"
    private let refreshControl = UIRefreshControl()
    private var viewModel: CollectionViewViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        activityIndicator.isHidden = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshArticles(_:)), for: .valueChanged)
        viewModel = CollectionViewViewModel()
        viewModel?.fetchArticles {
            [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.isHidden = true
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
        guard
            let detail = storyboard?.instantiateViewController(withIdentifier: "ShowDetail") as? DetailVC,
            let viewModel = viewModel else {
            fatalError("DetailVC wasn't configured")
        }
        viewModel.selectRow(atIndexPath: indexPath)
        detail.viewModel = viewModel.viewModelForSelectedRow()
        navigationController?.pushViewController(detail, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width - 10, height: 100)
    }
}
