//
//  TopHeadlinesResponse.swift
//  NewsApp
//
//  Created by user on 05/10/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import Foundation

struct TopHeadlinesResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
