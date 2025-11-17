//
//  CatsDTO.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

struct CatBreedsResponseDTO: Decodable {
    let data: [CatBreedDTO]
    let last_page: Int
    let current_page: Int
}

struct CatBreedDTO: Decodable {
    let breed: String?
    let country: String?
    let origin: String?
    let coat: String?
    let pattern: String?
}

