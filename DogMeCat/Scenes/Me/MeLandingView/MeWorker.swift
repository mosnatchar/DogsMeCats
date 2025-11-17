//
//  MeWorker.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import Foundation

final class MeWorker: MeWorkerProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let endpoint = APIEndpoint(
            path: .user,
        )

        apiClient.request(endpoint) { (result: Result<RandomUserResponseDTO, Error>) in
            switch result {
            case .success(let dto):
                guard let first = dto.results.first else {
                    completion(.failure(APIError.noData))
                    return
                }
                completion(.success(first.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
