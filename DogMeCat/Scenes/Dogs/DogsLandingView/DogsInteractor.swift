//
//  DogsInteractor.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import Foundation

final class DogsInteractor: DogsBusinessLogic {
    var presenter: DogsPresentationLogic?
    var worker: DogsWorkerProtocol

    init(worker: DogsWorkerProtocol = DogsWorker()) {
        self.worker = worker
    }

    func loadInitialDogs(request: Dogs.Load.Request) {
        presenter?.presentLoading(isLoading: true)
        worker.fetchDogsConcurrent(count: 3) { [weak self] result in
            guard let self else { return }
            self.presenter?.presentLoading(isLoading: false)

            switch result {
            case .success(let images):
                let response = Dogs.Load.Response(images: images)
                self.presenter?.presentDogs(response: response)
            case .failure(let error):
                self.presenter?.presentError(error: error)
            }
        }
    }

    func reloadConcurrent(request: Dogs.ReloadConcurrent.Request) {
        presenter?.presentLoading(isLoading: true)
        worker.fetchDogsConcurrent(count: 3) { [weak self] result in
            guard let self else { return }
            self.presenter?.presentLoading(isLoading: false)

            switch result {
            case .success(let images):
                let response = Dogs.ReloadConcurrent.Response(images: images)
                self.presenter?.presentReloadConcurrent(response: response)
            case .failure(let error):
                self.presenter?.presentError(error: error)
            }
        }
    }

    func reloadSequential(request: Dogs.ReloadSequential.Request) {
        let seconds = Calendar.current.component(.second, from: request.buttonPressedAt)
        let lastDigit = seconds % 10
        print("last Digit: \(lastDigit)")
        let delay = lastDigit < 5 ? 2 : 3
        
        presenter?.presentLoading(isLoading: true)

        worker.fetchDogsSequential(count: 3, delaySeconds: delay) { [weak self] result in
            guard let self else { return }
            self.presenter?.presentLoading(isLoading: false)

            switch result {
            case .success(let images):
                let response = Dogs.ReloadSequential.Response(
                    images: images,
                    delaySeconds: delay
                )
                self.presenter?.presentReloadSequential(response: response)
            case .failure(let error):
                self.presenter?.presentError(error: error)
            }
        }
    }
}

