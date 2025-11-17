//
//  UIButton.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 15/11/2568 BE.
//

import UIKit

extension UIButton {
    func setButton() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.backgroundColor = UIColor.systemBlue
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitleColor(.white, for: .normal)
    }
}
