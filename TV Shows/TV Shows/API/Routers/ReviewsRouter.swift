//
//  ReviewsRouter.swift
//  TV Shows
//
//  Created by Infinum on 24.07.2022..
//

import Alamofire

enum ReviewsRouter: URLRequestConvertible {
    
    case getAll(authInfo: AuthInfo, showId: String, pageNumber: Int)
    case create(authInfo: AuthInfo, review: NewReview)
        
    var path: String {
        switch self {
        case .getAll(_, let showId, _):
            return "shows/\(showId)/reviews"
        case .create:
            return "reviews"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAll:
            return .get
        case .create:
            return .post
        }
    }
    
    var parameters: Parameters? {
        let pageSize = 20
        switch self {
        case .getAll(_, _, let pageNumber):
            return ["page": String(pageNumber), "items": String(pageSize)]
        case .create(_, let review):
            return [
                "rating" : review.rating,
                "comment" : review.comment,
                "show_id" : review.showId
            ]
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getAll(let authInfo, _, _), .create(let authInfo, _):
            return HTTPHeaders(authInfo.headers)
        }
    }
    
    var encodingType: ParameterEncoding {
        switch self {
        case .getAll:
            return URLEncoding.default
        case .create:
            return JSONEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try URL(string: Constants.apiBaseUrl.asURL()
                                                  .appendingPathComponent(path)
                                                  .absoluteString.removingPercentEncoding!)
        var request = URLRequest.init(url: url!)
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10*1000)
        request.headers = headers
        return try encodingType.encode(request, with: parameters)
    }
    
}

struct NewReview {
    let rating: Int
    let showId: Int
    let comment: String
}
