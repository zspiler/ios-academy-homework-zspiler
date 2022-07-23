//
//  Shows.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import Foundation

struct ShowsResponse: Decodable {
    let shows: [Show]
}

struct Show: Codable {
    let id: String
    let title: String
    let description: String?
    let imageUrl: String
    let averageRating: Double?
    let numOfReviews: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imageUrl = "image_url"
        case averageRating = "average_rating"
        case numOfReviews = "no_of_reviews"
    }
}

//{
//"id": "12",
//"average_rating": null,
//"description": null,
//"image_url": "memory://dc9b3b6310caf31d0254e517fadb5762",
//"no_of_reviews": 0,
//"title": "Tv Show 12"
//},
