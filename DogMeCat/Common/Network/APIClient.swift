//
//  Network.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import Foundation
import Alamofire

enum APIError: Error {
    case invalidURL
    case noData
    case decodingFailed
    case unknown(Error)
}

enum APIHost {
    case dog
    case cat
    case user

    var baseURLString: String {
        switch self {
        case .dog:
            return "https://dog.ceo"
        case .cat:
            return "https://catfact.ninja"
        case .user:
            return "https://randomuser.me"
        }
    }

}

enum Path {
    case dog
    case cat
    case user

    var pathURLString: String {
        switch self {
        case .dog:
            APIHost.dog.baseURLString + "/api/breeds/image/random"
        case .cat:
            APIHost.cat.baseURLString + "/breeds"
        case .user:
            APIHost.user.baseURLString + "/api"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .dog, .cat, .user:
            return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .dog, .cat, .user:
            return URLEncoding.default
        }
    }
}


struct APIEndpoint {
    let path: Path
    let parameters: Parameters?
    let headers: HTTPHeaders?

    init(
        path: Path,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) {
        self.path = path
        self.parameters = parameters
        self.headers = headers
    }

    var urlString: String {
        path.pathURLString
    }
}

