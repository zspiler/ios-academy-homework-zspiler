//
//  Shows.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import Foundation

struct ShowsResponse: Decodable {
    let shows: [Show]
    let meta: Metadata
}

struct Show: Codable {
    let id: String
    let title: String
    let description: String?
    let imageUrl: URL
    let averageRating: Double?
    let numberOfReviews: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imageUrl = "image_url"
        case averageRating = "average_rating"
        case numberOfReviews = "no_of_reviews"
    }
}

struct Metadata: Codable {
    let pagination: PaginationMetadata
}

struct PaginationMetadata: Codable {
    let count: Int
    let page: Int
    let items: Int
    let pages: Int
}
