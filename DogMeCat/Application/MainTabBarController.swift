//
//  MainTabBarController.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupTabs()
        delegate = self
    }

    // MARK: - Setup

    private func setupTabs() {
           let navDogs = UINavigationController()
           let navCats = UINavigationController()
           let navMe = UINavigationController()

           // Dogs
           let dogsVC = UIStoryboard(name: "DogsStoryboard", bundle: nil)
               .instantiateViewController(identifier: "DogsVC")
           dogsVC.tabBarItem = UITabBarItem(
               title: "Dogs",
               image: UIImage(named: "dog"),
               selectedImage: UIImage(named: "dog")
           )

           dogsVC.navigationItem.title = "Dog + Cat & I"
           navDogs.setViewControllers([dogsVC], animated: false)

           // Cats
           let catsVC = UIStoryboard(name: "CatsStoryboard", bundle: nil)
               .instantiateViewController(identifier: "CatsVC")
           catsVC.tabBarItem = UITabBarItem(
               title: "Cats",
               image: UIImage(named: "cat"),
               selectedImage: UIImage(named: "cat")
           )
           catsVC.navigationItem.title = "Dog + Cat & I"
           navCats.setViewControllers([catsVC], animated: false)

           // Me
           let meVC = UIStoryboard(name: "MeStoryboard", bundle: nil)
               .instantiateViewController(identifier: "MeVC")
           meVC.tabBarItem = UITabBarItem(
               title: "Me",
               image: UIImage(named: "profile"),
               selectedImage: UIImage(named: "profile")
           )
           meVC.navigationItem.title = "Dog + Cat & I"
           navMe.setViewControllers([meVC], animated: false)

           viewControllers = [navDogs, navCats, navMe]
           selectedIndex = 0
       }

       // MARK: - Appearance

       private func setupAppearance() {
           let tabAppr = UITabBarAppearance()
           tabAppr.configureWithDefaultBackground()
           tabBar.standardAppearance = tabAppr
           tabBar.scrollEdgeAppearance = tabAppr
       }

}

// MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == selectedViewController {

        }
        return true
    }
    
}
