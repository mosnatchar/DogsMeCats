//
//  SplashViewController.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 15/11/2568 BE.
//

import UIKit

final class SplashViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.moveToMainApp()
        }
    }

    private func setupLayout() {
        
    }

    private func moveToMainApp() {
        let mainTabBar = MainTabBarController()

        // เปลี่ยน rootViewController
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = mainTabBar
            UIView.transition(with: window,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
}
