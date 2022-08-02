//
//  ShowsRouter.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import Alamofire

enum ShowsRouter: URLRequestConvertible {
    
    case getAll(authInfo: AuthInfo, pageNumber: Int)
        
    var path: String {
        let endpoint = "shows"
        switch self {
        case .getAll:
            return "\(endpoint)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAll:
            return .get
        }
    }
    
    var parameters: Parameters? {
        let pageSize = 30
        switch self {
        case .getAll(_, let pageNumber):
            return ["page": String(pageNumber), "items": String(pageSize)]
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getAll(let authInfo, _):
            return HTTPHeaders(authInfo.headers)
        }
    }
    
    var encodingType: ParameterEncoding {
        switch self {
        case .getAll:
            return URLEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try URL(string: Constants.Networking.apiBaseUrl.asURL()
                                                  .appendingPathComponent(path)
                                                  .absoluteString.removingPercentEncoding!)
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        request.headers = headers
        return try encodingType.encode(request,with: parameters)
    }

}
