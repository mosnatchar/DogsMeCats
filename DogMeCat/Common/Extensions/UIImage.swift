//
//  UIImage.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 15/11/2568 BE.
//

import UIKit

extension UIImageView {
    func setImage(from urlString: URL, placeholder: UIImage? = nil) {
        self.image = placeholder

        URLSession.shared.dataTask(with: urlString) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
