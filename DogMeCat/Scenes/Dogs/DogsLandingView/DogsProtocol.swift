//
//  DogsProtocol.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//


protocol DogsBusinessLogic {
    func loadInitialDogs(request: Dogs.Load.Request)
    func reloadConcurrent(request: Dogs.ReloadConcurrent.Request)
    func reloadSequential(request: Dogs.ReloadSequential.Request)
}

protocol DogsDisplayLogic: AnyObject {
    func displayDogs(viewModel: Dogs.Load.ViewModel)
    func displayReloadSequential(viewModel: Dogs.ReloadSequential.ViewModel)
    func displayLoading(viewModel: Dogs.Loading.ViewModel)
    func displayError(viewModel: Dogs.Error.ViewModel)
}

protocol DogsPresentationLogic {
    func presentDogs(response: Dogs.Load.Response)
    func presentReloadConcurrent(response: Dogs.ReloadConcurrent.Response)
    func presentReloadSequential(response: Dogs.ReloadSequential.Response)
    func presentLoading(isLoading: Bool)
    func presentError(error: Error)
}

protocol DogsWorkerProtocol {
    func fetchDogsConcurrent(count: Int, completion: @escaping (Result<[DogImage], Error>) -> Void )

    func fetchDogsSequential(
        count: Int,
        delaySeconds: Int,
        completion: @escaping (Result<[DogImage], Error>) -> Void
    )
}

protocol DogsRoutingLogic {
    func routeToMeTab()
}
