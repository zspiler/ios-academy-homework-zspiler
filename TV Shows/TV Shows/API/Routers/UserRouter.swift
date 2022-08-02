//
//  UserRouter.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2022..
//

import Alamofire

enum UserRouter: URLRequestConvertible {
    
    case getUser(authInfo: AuthInfo)
    case updateUser(authInfo: AuthInfo)
        
    var path: String {
        switch self {
        case .getUser:
            return "users/me"
        case .updateUser:
            return "users"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUser:
            return .get
        case .updateUser:
            return .put
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getUser, .updateUser:
            return nil
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getUser(let authInfo):
            return HTTPHeaders(authInfo.headers)
        case .updateUser:
            return [:]
        }
    }
    
    var encodingType: ParameterEncoding {
        switch self {
        case .getUser:
            return JSONEncoding.default
        case .updateUser:
            return JSONEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try URL(string: Constants.Networking.apiBaseUrl.asURL()
                                                  .appendingPathComponent(path)
                                                  .absoluteString.removingPercentEncoding!)
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        request.headers = headers
        return try encodingType.encode(request, with: parameters)
    }
 
}
