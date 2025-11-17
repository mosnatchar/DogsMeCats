//
//  MeInteractor.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import Foundation

final class MeInteractor: MeBusinessLogic, MeDataStore {

    var presenter: MePresentationLogic?
    var worker: MeWorkerProtocol

    var profile: UserProfile?

    init(worker: MeWorkerProtocol = MeWorker()) {
        self.worker = worker
    }

    func loadProfile(request: Me.Load.Request) {
        presenter?.presentLoading(isLoading: true)
        worker.fetchProfile { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                self.presenter?.presentLoading(isLoading: false)

                switch result {
                case .success(let profile):
                    self.profile = profile
                    let response = Me.Load.Response(profile: profile)
                    self.presenter?.presentProfile(response: response)
                case .failure(let error):
                    self.presenter?.presentError(error: error)
                }
            }
        }
    }
}
