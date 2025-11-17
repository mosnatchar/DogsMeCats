//
//  BaseUIViewController.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 15/11/2568 BE.
//

import UIKit

class BaseViewController: UIViewController {

    let loading = UIActivityIndicatorView(style: .large)
    private let loadingBackgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView()
        setupNavigationBar()
    }
    
    func loadingView() {
        
        // Setup background view
        loadingBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loadingBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        loadingBackgroundView.isHidden = true
        
        view.addSubview(loadingBackgroundView)
        view.addSubview(loading)

        loading.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            loadingBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loading.centerXAnchor.constraint(equalTo: loadingBackgroundView.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: loadingBackgroundView.centerYAnchor),
        ])
    }
    
    func showLoading() {
        loadingBackgroundView.isHidden = false
        loading.startAnimating()
    }
    
    func hideLoading() {
        loadingBackgroundView.isHidden = true
        loading.stopAnimating()
    }
    
    func setupNavigationBar() {

        let leftIcon = UIBarButtonItem(
            image: UIImage(named: "dog_n_cat"),
            style: .plain,
            target: self,
            action: #selector(didTapDogCat)
        )
        navigationItem.leftBarButtonItem = leftIcon

        let profileButton = UIBarButtonItem(
            image: UIImage(named: "account"),
            style: .plain,
            target: self,
            action: #selector(didTapProfile)
        )
        navigationItem.rightBarButtonItem = profileButton
    }

    @objc open func didTapProfile() {
    }
    
    @objc open func didTapDogCat() {
    }
    
}
