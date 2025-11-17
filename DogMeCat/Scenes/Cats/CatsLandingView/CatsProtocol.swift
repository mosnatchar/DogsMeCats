//
//  CatsProtocol.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//


protocol CatsWorkerProtocol {
    func fetchBreeds(page: Int, completion: @escaping (Result<CatBreedsResponse, Error>) -> Void)
}

protocol CatsPresentationLogic {
    func presentBreeds(response: Cats.Load.Response)
    func presentToggle(response: Cats.Toggle.Response)
    func presentLoading(isLoading: Bool)
    func presentError(error: Error)
}

protocol CatsDisplayLogic: AnyObject {
    func displayBreeds(viewModel: Cats.Load.ViewModel)
    func displayLoading(viewModel: Cats.Loading.ViewModel)
    func displayError(viewModel: Cats.Error.ViewModel)
}

protocol CatsBusinessLogic {
    func loadBreeds(request: Cats.Load.Request)
    func loadMoreBreeds(request: Cats.Load.Request)
    func toggleBreed(request: Cats.Toggle.Request)
}

protocol CatsRoutingLogic {
    func routeToMeTab()
}

