//
//  User.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import Foundation

struct UserResponse: Decodable {
    let user: User
}

struct UserData: Codable {
    let user: User
    let authInfo: AuthInfo
}

struct User: Codable {
    let id: String
    let email: String
    let imageUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case email
        case id
        case imageUrl = "image_url"
    }
}


struct AuthInfo: Codable {

    let accessToken: String
    let client: String
    let tokenType: String
    let expiry: String
    let uid: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access-token"
        case client = "client"
        case tokenType = "token-type"
        case expiry = "expiry"
        case uid = "uid"
    }

    // MARK: Helpers
    
    init(headers: [String: String]) throws {
        let data = try JSONSerialization.data(withJSONObject: headers, options: .prettyPrinted)
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }

    var headers: [String: String] {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
            return jsonObject as? [String: String] ?? [:]
        } catch {
            return [:]
        }
    }
}
