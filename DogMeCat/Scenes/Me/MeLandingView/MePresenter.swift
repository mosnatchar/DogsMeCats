//
//  MePresenter.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import Foundation

final class MePresenter: MePresentationLogic {

    weak var viewController: MeDisplayLogic?

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f
    }()

    func presentProfile(response: Me.Load.Response) {
        let profile = response.profile

        let fullName = "\(profile.title) \(profile.firstName) \(profile.lastName)"
        let dobText = dateFormatter.string(from: profile.dateOfBirth)
        let ageText = "Age: \(profile.age)"

        let genderIconName: String
        switch profile.gender.lowercased() {
        case "male":
            genderIconName = "male-gender"
        case "female":
            genderIconName = "femal-gender"
        default:
            genderIconName = "icon_gender_unknown"
        }
        
        let viewModel = Me.Load.ViewModel(
            fullName: fullName,
            title: "Title: \(profile.title)" ,
            firstName: "Firstname: \(profile.firstName)",
            lastName: "Lastname: \(profile.lastName)",
            dateOfBirth: "Date of Birth: \(dobText)",
            ageText: "Age: \(ageText)",
            genderIconName: genderIconName,
            nationality: "Nationality: \(profile.nationality)",
            mobile: "Mobile: \(profile.mobile)",
            address: "Address: \(profile.address)" ,
            profileImageURL: profile.profileImageURL
        )

        viewController?.displayProfile(viewModel: viewModel)
    }

    func presentLoading(isLoading: Bool) {
        viewController?.displayLoading(
            viewModel: Me.Loading.ViewModel(isLoading: isLoading)
        )
    }

    func presentError(error: Error) {
        viewController?.displayError(
            viewModel: Me.Error.ViewModel(message: error.localizedDescription)
        )
    }
}

