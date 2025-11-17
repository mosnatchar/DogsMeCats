//
//  CatsWorker.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import Foundation


final class CatsWorker: CatsWorkerProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchBreeds(page: Int = 1, completion: @escaping (Result<CatBreedsResponse, Error>) -> Void) {
        let endpoint = APIEndpoint(
            path: .cat,
            parameters: ["page": page]
        )

        apiClient.request(endpoint) { (result: Result<CatBreedsResponseDTO, Error>) in
            switch result {
            case .success(let dto):
                let breeds = dto.data.map { d in
                    CatBreed(
                        name: d.breed ?? "-",
                        country: d.country ?? "-",
                        origin: d.origin ?? "-",
                        coat: d.coat ?? "-",
                        pattern: d.pattern ?? "-"
                    )
                }
                
                let pagination = CatBreedsPagination(
                    currentPage: dto.current_page,
                    lastPage: dto.last_page
                )
                
                let response = CatBreedsResponse(
                    breeds: breeds,
                    pagination: pagination
                )
                
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

