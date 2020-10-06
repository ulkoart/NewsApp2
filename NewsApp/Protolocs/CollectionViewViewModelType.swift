//
//  CollectionViewViewModelType.swift
//  NewsApp
//
//  Created by user on 06/10/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import Foundation

protocol CollectionViewViewModelType {
    func numberOfRows() -> Int
    func fetchArticles(completionHandler: @escaping() -> ())
    func cellViewModel(forIndexPath indexPath: IndexPath) -> CollectionViewCellViewModelType?
    func viewModelForSelectedRow() -> DetailViewModelType?
    func selectRow(atIndexPath indexPath: IndexPath)
}
