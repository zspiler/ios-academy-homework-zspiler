//
//  API.swift
//  TV Shows
//
//  Created by Infinum on 20.07.2022..
//

import Alamofire

enum AuthRouter: URLRequestConvertible {
    
    case login(user: User)
    case register(user: User)

    var path: String {
        let endpoint = "users"
        switch self {
        case .register:
            return "\(endpoint)"
        case .login :
            return "\(endpoint)/sign_in"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .register:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let user):
            return [
                "email" : user.email,
                "password" : user.password
            ]
        case .register(let user):
            return [
                "email" : user.email,
                "password" : user.password,
                "confirm_password" : user.password
            ]
        }
    }
    
    var encodingType: ParameterEncoding {
        switch self {
        case .login, .register:
            return JSONEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try URL(string: Constants.Networking.apiBaseUrl.asURL()
                                                  .appendingPathComponent(path)
                                                  .absoluteString.removingPercentEncoding!)
        var request = URLRequest.init(url: url!)
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10*1000)
        return try encodingType.encode(request,with: parameters)
    }
    
    struct User {
        let email: String
        let password: String
    }
}
