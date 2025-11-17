//
//  DogsWorkerProtocol.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import Foundation

final class DogsWorker: DogsWorkerProtocol {
    
    private let apiClient: APIClientProtocol
    
    private var timer: Timer?
    private(set) var remainingSeconds: Int = 0
    
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    
    func fetchDogsConcurrent(
        count: Int,
        completion: @escaping (Result<[DogImage], Error>) -> Void
    ) {
        let group = DispatchGroup()
        var results: [DogImage] = []
        var firstError: Error?
        
        for index in 0..<count {
            print("round call api:",index)
            group.enter()
            let endpoint = APIEndpoint(
                path: .dog
            )
            
            apiClient.request(endpoint) { (result: Result<DogImageResponseDTO, Error>) in
                defer { group.leave() }
                
                switch result {
                case .success(let dto):
                    if let url = URL(string: dto.message) {
                        let timeStamp = Date()
                        results.append(DogImage(url: url, time: timeStamp))
                        print("success round:", index)
                    }
                case .failure(let error):
                    if firstError == nil {
                        firstError = error
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            if let error = firstError, results.isEmpty {
                completion(.failure(error))
            } else {
                completion(.success(results))
            }
        }
    }
    
    // MARK: - Sequential
    
    func fetchDogsSequential(
        count: Int,
        delaySeconds: Int,
        completion: @escaping (Result<[DogImage], Error>) -> Void
    ) {
        var results: [DogImage] = []
        var index = 0
        countdownTimer(from: delaySeconds)
        func performNext() {
            guard index < count else {
                completion(.success(results))
                return
            }
            
            let endpoint = APIEndpoint(
                path: .dog,
            )
            apiClient.request(endpoint) { (result: Result<DogImageResponseDTO, Error>) in
                switch result {
                case .success(let dto):
                    if let url = URL(string: dto.message) {
                        let timeStamp = Date()
                        results.append(DogImage(url: url,time: timeStamp))
                    }
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
                
                index += 1
                print("round call :",index)
                if index < count {
                    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(delaySeconds)) {
                        performNext()
                    }
                } else {
                    completion(.success(results))
                }
            }
        }
        
        performNext()
    }
    
    func countdownTimer(from seconds: Int) {
        let total = seconds*3
        print("Time call Total :",total)
        timer?.invalidate()
        remainingSeconds = total
        print("Time start...")
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] t in
            guard let self else { return }
            self.remainingSeconds -= 1
            
            if self.remainingSeconds > 0 {
                print("Time:",self.remainingSeconds)
            } else {
                print("Time out...")
                t.invalidate()
            }
        }
        
        RunLoop.main.add(timer!, forMode: .common)
    }
}
