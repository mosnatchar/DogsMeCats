//
//  RandomUserMapping.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import Foundation

extension RandomUserDTO {
    func toDomain() -> UserProfile {
        // parse date
        let isoFormatter = ISO8601DateFormatter()
        let dobDate = isoFormatter.date(from: dob.date) ?? Date()

        let address = "\(location.street.number) \(location.street.name), \(location.city), \(location.state) \(location.postcode.value), \(location.country)"

        let url = URL(string: picture.large)

        return UserProfile(
            title: name.title,
            firstName: name.first,
            lastName: name.last,
            dateOfBirth: dobDate,
            age: dob.age,
            gender: gender,
            nationality: nat,
            mobile: cell,
            address: address,
            profileImageURL: url
        )
    }
}
