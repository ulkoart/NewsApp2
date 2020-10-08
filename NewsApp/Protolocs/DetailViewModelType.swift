//
//  DetailViewModelType.swift
//  NewsApp
//
//  Created by user on 06/10/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import Foundation

protocol DetailViewModelType {
    var title: String { get }
    var sourse: String { get }
    var description: String? { get }
    var url: String { get }
}
