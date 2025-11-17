//
//  APIClientProtocol.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//
import Foundation
import Alamofire

protocol APIClientProtocol {
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

final class APIClient: APIClientProtocol {

    static let shared = APIClient()

    private let session: Session
    private let decoder: JSONDecoder

    init(session: Session = .default, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: endpoint.urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        session.request(
            url,
            method: endpoint.path.method,
            parameters: endpoint.parameters,
            encoding: endpoint.path.encoding,
            headers: endpoint.headers
        )
        .validate()
        .responseDecodable(of: T.self, decoder: decoder) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let afError):
                completion(.failure(APIError.unknown(afError)))
            }
        }
    }
}

