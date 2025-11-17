//
//  CatsModels.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//
import Foundation

enum Cats {
    enum Load {
        struct Request {
            let page: Int
            
            init(page: Int = 1) {
                self.page = page
            }
        }

        struct Response {
            let breeds: [CatBreed]
            let selectedIndex: Int?
            let pagination: CatBreedsPagination
        }

        struct ViewModel {
            struct BreedItem {
                let name: String
                let detailText: String?
                let isExpanded: Bool
            }
            let items: [BreedItem]
            let canLoadMore: Bool
            let currentPage: Int
        }
    }

    enum Toggle {
        struct Request {
            let index: Int
        }

        struct Response {
            let breeds: [CatBreed]
            let selectedIndex: Int?
        }
    }

    enum Loading {
        struct ViewModel {
            let isLoading: Bool
        }
    }

    enum Error {
        struct ViewModel {
            let message: String
        }
    }
}
