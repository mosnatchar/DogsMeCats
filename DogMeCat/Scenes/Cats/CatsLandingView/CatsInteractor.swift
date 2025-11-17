//
//  CatsInteractor.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import Foundation

final class CatsInteractor: CatsBusinessLogic {

    var presenter: CatsPresentationLogic?
    var worker: CatsWorkerProtocol

    private var breeds: [CatBreed] = []
    private var selectedIndex: Int?
    private var pagination: CatBreedsPagination?

    init(worker: CatsWorkerProtocol = CatsWorker()) {
        self.worker = worker
    }

    // MARK: - Load

    func loadBreeds(request: Cats.Load.Request) {
        presenter?.presentLoading(isLoading: true)
        worker.fetchBreeds(page: request.page) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                self.presenter?.presentLoading(isLoading: false)
                switch result {
                case .success(let response):
                    self.breeds = response.breeds
                    self.pagination = response.pagination
                    
                    let loadResponse = Cats.Load.Response(
                        breeds: response.breeds,
                        selectedIndex: self.selectedIndex,
                        pagination: response.pagination
                    )
                    self.presenter?.presentBreeds(response: loadResponse)
                case .failure(let error):
                    self.presenter?.presentError(error: error)
                }
            }
        }
    }
    
    // MARK: - Load More
    
    func loadMoreBreeds(request: Cats.Load.Request) {
        guard let nextPage = pagination?.nextPage else {
            return
        }
        
        presenter?.presentLoading(isLoading: true)
        
        let nextRequest = Cats.Load.Request(page: nextPage)
        worker.fetchBreeds(page: nextRequest.page) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                self.presenter?.presentLoading(isLoading: false)
                switch result {
                case .success(let response):
                    self.breeds.append(contentsOf: response.breeds)
                    self.pagination = response.pagination
                    
                    let loadResponse = Cats.Load.Response(
                        breeds: self.breeds,
                        selectedIndex: self.selectedIndex,
                        pagination: response.pagination
                    )
                    self.presenter?.presentBreeds(response: loadResponse)
                case .failure(let error):
                    self.presenter?.presentError(error: error)
                }
            }
        }
    }

    // MARK: - Toggle

    func toggleBreed(request: Cats.Toggle.Request) {
        guard !breeds.isEmpty, let pagination = pagination else { return }

        if selectedIndex == request.index {
            selectedIndex = nil
        } else {
            selectedIndex = request.index
        }

        let response = Cats.Toggle.Response(
            breeds: breeds,
            selectedIndex: selectedIndex
        )
        presenter?.presentToggle(response: response)
    }
}
