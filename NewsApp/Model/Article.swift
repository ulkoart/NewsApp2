//
//  Article.swift
//  NewsApp
//
//  Created by user on 05/10/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import Foundation

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let articleDescription: String?
    let url: String
    let urlToImage: String? // ToDo check https if protocol http
    let publishedAt: String
    let content: String?
    
    let imageData: Data?
    let offLine: Bool?

    enum CodingKeys: String, CodingKey {
        case source, author, title, url, urlToImage, publishedAt, content, imageData, offLine
        case articleDescription = "description"
    }
}
