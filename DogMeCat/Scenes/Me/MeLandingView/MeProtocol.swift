//
//  MeProtocol.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

protocol MeBusinessLogic {
    func loadProfile(request: Me.Load.Request)
}

protocol MeDataStore {
    var profile: UserProfile? { get set }
}

protocol MePresentationLogic {
    func presentProfile(response: Me.Load.Response)
    func presentLoading(isLoading: Bool)
    func presentError(error: Error)
}

protocol MeDisplayLogic: AnyObject {
    func displayProfile(viewModel: Me.Load.ViewModel)
    func displayLoading(viewModel: Me.Loading.ViewModel)
    func displayError(viewModel: Me.Error.ViewModel)
}

protocol MeRoutingLogic {
}

protocol MeWorkerProtocol {
    func fetchProfile(completion: @escaping (Result<UserProfile, Error>) -> Void)
}
