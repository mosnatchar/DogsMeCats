//
//  DogsPresenter.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import Foundation

final class DogsPresenter: DogsPresentationLogic {
    weak var viewController: DogsDisplayLogic?

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return f
    }()

    func presentDogs(response: Dogs.Load.Response) {
        let items = response.images.enumerated().map { index, dog in
            Dogs.Load.ViewModel.DogItem(
                title: "Dog#\(index + 1)",
                imageURL: dog.url,
                timestampText: dateFormatter.string(from: dog.time)
            )
        }
        viewController?.displayDogs(
            viewModel: Dogs.Load.ViewModel(items: items)
        )
    }

    func presentReloadConcurrent(response: Dogs.ReloadConcurrent.Response) {
        let items = response.images.enumerated().map { index, dog in
            Dogs.Load.ViewModel.DogItem(
                title: "Dog#\(index + 1)",
                imageURL: dog.url,
                timestampText: dateFormatter.string(from: dog.time)
            )
        }
        viewController?.displayDogs(
            viewModel: Dogs.Load.ViewModel(items: items)
        )
    }

    func presentReloadSequential(response: Dogs.ReloadSequential.Response) {
        let items = response.images.enumerated().map { index, dog in
            Dogs.Load.ViewModel.DogItem(
                title: "Dog#\(index + 1)",
                imageURL: dog.url,
                timestampText: dateFormatter.string(from: dog.time)
            )
        }
        let vm = Dogs.ReloadSequential.ViewModel(
            items: items,
            delayDescription: "Delay \(response.delaySeconds)s"
        )
        viewController?.displayReloadSequential(viewModel: vm)
    }

    func presentLoading(isLoading: Bool) {
        viewController?.displayLoading(
            viewModel: Dogs.Loading.ViewModel(isLoading: isLoading)
        )
    }

    func presentError(error: Error) {
        viewController?.displayError(
            viewModel: Dogs.Error.ViewModel(message: error.localizedDescription)
        )
    }
}
