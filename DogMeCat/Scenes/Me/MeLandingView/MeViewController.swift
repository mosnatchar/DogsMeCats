//
//  MeViewController.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import UIKit

final class MeViewController: BaseViewController, MeDisplayLogic {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var reloadBtn: UIButton!
    
    var interactor: MeBusinessLogic?
    var router: MeRoutingLogic?
    var detailView: DetailMeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        interactor?.loadProfile(request: Me.Load.Request())
    }

    private func setup() {
        titleLabel.text = "Me"
        let interactor = MeInteractor()
        let presenter = MePresenter()
        let router = MeRouter()

        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self

        if let loadedView = DetailMeView.loadFromNib() {
            detailView = loadedView
            detailView.setuUI()
            stackView.addArrangedSubview(detailView)
        }
        reloadBtn.setButton()
        reloadBtn.setTitle("Reload Profile", for: .normal)
        reloadBtn.addTarget(.none, action: #selector(didTapProfile), for: .touchUpInside)
    }

    // MARK: - Actions
    
    override func didTapProfile() {
        interactor?.loadProfile(request: Me.Load.Request())
    }
    
    override func didTapDogCat() {
        
    }

    // MARK: - MeDisplayLogic

    func displayProfile(viewModel: Me.Load.ViewModel) {
        detailView.comfigure(viewModel: viewModel)
    }
    

    func displayLoading(viewModel: Me.Loading.ViewModel) {
        if viewModel.isLoading {
            showLoading()
            view.isUserInteractionEnabled = false
        } else {
            hideLoading()
            view.isUserInteractionEnabled = true
        }
    }

    func displayError(viewModel: Me.Error.ViewModel) {
        let alert = UIAlertController(title: "Error", message: viewModel.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }


}
