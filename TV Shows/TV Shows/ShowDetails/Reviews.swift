//
//  Reviews.swift
//  TV Shows
//
//  Created by Infinum on 24.07.2022..
//

import Foundation

struct ReviewsResponse: Decodable {
    let reviews: [Review]
    let meta: Metadata
}

struct Review: Codable {
    let id: String
    let comment: String?
    let rating: Int
    let showId: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case rating
        case showId = "show_id"
        case user
    }
}

