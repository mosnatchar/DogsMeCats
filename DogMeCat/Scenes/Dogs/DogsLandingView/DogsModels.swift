//
//  DogsModels.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import Foundation

enum Dogs {
    enum Load {
        struct Request { }
        struct Response {
            let images: [DogImage]
        }
        struct ViewModel {
            struct DogItem {
                let title: String
                let imageURL: URL
                let timestampText: String
            }
            let items: [DogItem]
        }
    }
    
    enum ReloadConcurrent {
        struct Request { }
        struct Response {
            let images: [DogImage]
        }
        struct ViewModel {
            let items: [Load.ViewModel.DogItem]
        }
    }
    
    enum ReloadSequential {
        struct Request {
            let buttonPressedAt: Date
        }
        struct Response {
            let images: [DogImage]
            let delaySeconds: Int
        }
        struct ViewModel {
            let items: [Load.ViewModel.DogItem]
            let delayDescription: String
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
