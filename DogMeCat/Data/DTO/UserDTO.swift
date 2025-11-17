//
//  RandomUserDTO.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

struct RandomUserResponseDTO: Decodable {
    let results: [RandomUserDTO]
}

struct RandomUserDTO: Decodable {
    struct NameDTO: Decodable {
        let title: String
        let first: String
        let last: String
    }

    struct DobDTO: Decodable {
        let date: String 
        let age: Int
    }

    struct LocationDTO: Decodable {
        struct StreetDTO: Decodable {
            let number: Int
            let name: String
        }
        let street: StreetDTO
        let city: String
        let state: String
        let country: String
        let postcode: Postcode

        enum Postcode: Decodable {
            case int(Int)
            case string(String)

            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                if let intValue = try? container.decode(Int.self) {
                    self = .int(intValue)
                } else if let stringValue = try? container.decode(String.self) {
                    self = .string(stringValue)
                } else {
                    self = .string("")
                }
            }

            var value: String {
                switch self {
                case .int(let v): return "\(v)"
                case .string(let s): return s
                }
            }
        }
    }

    struct PictureDTO: Decodable {
        let large: String
        let medium: String
        let thumbnail: String
    }

    let gender: String
    let name: NameDTO
    let dob: DobDTO
    let nat: String
    let phone: String
    let cell: String
    let location: LocationDTO
    let picture: PictureDTO
}
