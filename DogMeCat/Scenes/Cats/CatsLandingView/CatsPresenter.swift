//
//  CatsPresenter.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import Foundation

final class CatsPresenter: CatsPresentationLogic {

    weak var viewController: CatsDisplayLogic?

    func presentBreeds(response: Cats.Load.Response) {
        let viewModel = makeViewModel(
            breeds: response.breeds, 
            selectedIndex: response.selectedIndex,
            pagination: response.pagination
        )
        viewController?.displayBreeds(viewModel: viewModel)
    }

    func presentToggle(response: Cats.Toggle.Response) {
        let viewModel = makeViewModel(
            breeds: response.breeds, 
            selectedIndex: response.selectedIndex,
            pagination: CatBreedsPagination(currentPage: 1, lastPage: 1)
        )
        viewController?.displayBreeds(viewModel: viewModel)
    }

    func presentLoading(isLoading: Bool) {
        viewController?.displayLoading(
            viewModel: Cats.Loading.ViewModel(isLoading: isLoading)
        )
    }

    func presentError(error: Error) {
        viewController?.displayError(
            viewModel: Cats.Error.ViewModel(message: error.localizedDescription)
        )
    }

    // MARK: - Private

    private func makeViewModel(breeds: [CatBreed], selectedIndex: Int?, pagination: CatBreedsPagination) -> Cats.Load.ViewModel {
        let items: [Cats.Load.ViewModel.BreedItem] = breeds.enumerated().map { index, breed in
            let isExpanded = (index == selectedIndex)
            if isExpanded {
                return Cats.Load.ViewModel.BreedItem(
                    name: breed.name,
                    detailText: """
                      Country: \(breed.country)
                      Origin: \(breed.origin)
                      Coat: \(breed.coat)
                      Pattern: \(breed.pattern)
                      """,
                    isExpanded: isExpanded
                )
            }
            else {
                return Cats.Load.ViewModel.BreedItem(
                    name: breed.name,
                    detailText: nil,
                    isExpanded: isExpanded
                )
            }
        }

        return Cats.Load.ViewModel(
            items: items,
            canLoadMore: pagination.hasMorePages,
            currentPage: pagination.currentPage
        )
    }
}
