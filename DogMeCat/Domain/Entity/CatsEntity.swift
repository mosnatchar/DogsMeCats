//
//  Cats.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 15/11/2568 BE.
//

struct CatBreed {
    let name: String
    let country: String
    let origin: String
    let coat: String
    let pattern: String
}

struct CatBreedsPagination {
    let currentPage: Int
    let lastPage: Int
    let hasMorePages: Bool
    
    init(currentPage: Int, lastPage: Int) {
        self.currentPage = currentPage
        self.lastPage = lastPage
        self.hasMorePages = currentPage < lastPage
    }
    
    var nextPage: Int? {
        return hasMorePages ? currentPage + 1 : nil
    }
}

struct CatBreedsResponse {
    let breeds: [CatBreed]
    let pagination: CatBreedsPagination
}


