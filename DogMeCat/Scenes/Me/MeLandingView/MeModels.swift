//
//  MeModels.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//
import Foundation

enum Me {

    enum Load {
        struct Request { }

        struct Response {
            let profile: UserProfile
        }

        struct ViewModel {
            let fullName: String
            let title: String
            let firstName: String
            let lastName: String
            let dateOfBirth: String
            let ageText: String
            let genderIconName: String
            let nationality: String
            let mobile: String
            let address: String
            let profileImageURL: URL?
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

