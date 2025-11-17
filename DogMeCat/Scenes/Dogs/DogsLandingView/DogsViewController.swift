//
//  DogsViewController.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import UIKit

final class DogsViewController: BaseViewController, DogsDisplayLogic {
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var concurentBtn: UIButton!
    @IBOutlet weak var sequentinalBtn: UIButton!
    
    var interactor: DogsBusinessLogic?
    var router: DogsRoutingLogic?
    var viewModel: Dogs.Load.ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        interactor?.loadInitialDogs(request: Dogs.Load.Request())
        registerCollection()
    }

    func setup() {
        titleName.text = "Dogs"
        concurentBtn.setTitle("Concurrent Reload", for: .normal)
        sequentinalBtn.setTitle("sequential Reload", for: .normal)
        concurentBtn.setButton()
        sequentinalBtn.setButton()
        
        let interactor = DogsInteractor()
        let presenter = DogsPresenter()
        let router = DogsRouter()
        
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        concurentBtn.addTarget(self,
                               action: #selector(didTapConcurrentReload),
                               for: .touchUpInside)
        sequentinalBtn.addTarget(self,
                                 action: #selector(didTapSequentialReload),
                                 for: .touchUpInside)
    }
    
    func registerCollection() {
        collectionView.register(
            UINib(nibName: "DogCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "DogCollectionViewCell"
        )
    }
    
    // MARK: - Actions
    
    @objc func didTapConcurrentReload() {
        interactor?.reloadConcurrent(request: Dogs.ReloadConcurrent.Request())
    }
    
    @objc func didTapSequentialReload() {
        interactor?.reloadSequential(
            request: Dogs.ReloadSequential.Request(buttonPressedAt: Date())
        )
    }
    
    @objc func didTapProfileButton() {
        router?.routeToMeTab()
    }
    
    func displayDogs(viewModel: Dogs.Load.ViewModel) {
        self.viewModel = viewModel
        collectionView.reloadData()
    }
    
    func displayReloadSequential(viewModel: Dogs.ReloadSequential.ViewModel) {
        self.viewModel = Dogs.Load.ViewModel(items: viewModel.items)
        collectionView.reloadData()
    }
    
    
    func displayLoading(viewModel: Dogs.Loading.ViewModel) {
        if viewModel.isLoading {
            showLoading()
            view.isUserInteractionEnabled = false
        } else {
            hideLoading()
            view.isUserInteractionEnabled = true
        }
    }
    
    func displayError(viewModel: Dogs.Error.ViewModel) {
        let alert = UIAlertController(
            title: "Error",
            message: viewModel.message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override func didTapProfile() {
        router?.routeToMeTab()
    }
    
    override func didTapDogCat() {
        
    }
}
extension DogsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "DogCollectionViewCell",
            for: indexPath
        ) as? DogCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let vm = viewModel?.items[indexPath.item] else { return cell }
        let title = "\(vm.title) @ \(vm.timestampText)"
        cell.configure(title: title, image: vm.imageURL)
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemsPerRow: CGFloat = 2
        let inset: CGFloat = 8
        let spacing: CGFloat = 8

        let totalInset = inset * 2
        let totalSpacing = spacing * (itemsPerRow - 1)

        let width = (collectionView.bounds.width - totalInset - totalSpacing) / itemsPerRow

        return CGSize(width: width, height: width + 40)
    }

}
