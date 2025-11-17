//
//  CatsViewController.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import UIKit

final class CatsViewController: BaseViewController, CatsDisplayLogic {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var interactor: CatsBusinessLogic?
    var router: CatsRoutingLogic?

    private var items: [Cats.Load.ViewModel.BreedItem] = []
    private var canLoadMore: Bool = false
    private var currentPage: Int = 1
    private var isLoadingMore: Bool = false

    // MARK: - UI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        interactor?.loadBreeds(request: Cats.Load.Request())
        register()
    }

    private func setup() {
        titleLabel.text = "Cats"

        let interactor = CatsInteractor()
        let presenter = CatsPresenter()
        let router = CatsRouter()

        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self

        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // TableView styling
        tableView.layer.cornerRadius = 8
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.masksToBounds = true
        
        tableView.sectionHeaderTopPadding = 0
    }
    
    private func register(){
        tableView.register(CatBreedCell.self, forCellReuseIdentifier: "CatBreedCell")
    }


    // MARK: - CatsDisplayLogic

    func displayBreeds(viewModel: Cats.Load.ViewModel) {
        self.items = viewModel.items
        self.canLoadMore = viewModel.canLoadMore
        self.currentPage = viewModel.currentPage
        self.isLoadingMore = false
        tableView.reloadData()

    }

    func displayLoading(viewModel: Cats.Loading.ViewModel) {
        if viewModel.isLoading {
            if currentPage == 1 {
                showLoading()
                view.isUserInteractionEnabled = false
            }
        } else {
            hideLoading()
            view.isUserInteractionEnabled = true
        }
    }

    func displayError(viewModel: Cats.Error.ViewModel) {
        isLoadingMore = false
        
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
    
    // MARK: - Load More
    
    private func loadMoreBreeds() {
        guard canLoadMore, !isLoadingMore else {
            return
        }
        
        isLoadingMore = true
        
        let request = Cats.Load.Request(page: currentPage + 1)
        interactor?.loadMoreBreeds(request: request)
    }
    
}

// MARK: - UITableView

extension CatsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CatBreedCell", for: indexPath) as? CatBreedCell else {
            return UITableViewCell()
        }

        let item = items[indexPath.row]
        cell.configure(with: item)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.toggleBreed(
            request: Cats.Toggle.Request(index: indexPath.row)
        )
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Pagination
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = items.count - 1
        let threshold = 3
        
        if indexPath.row >= lastIndex - threshold {
            loadMoreBreeds()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "Cat Breeds"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard isLoadingMore || canLoadMore else { return nil }
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60))
        footerView.backgroundColor = .systemBackground
        
        if isLoadingMore {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()
            
            footerView.addSubview(spinner)
            
            NSLayoutConstraint.activate([
                spinner.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
                spinner.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
            ])
        } else if canLoadMore {
            let label = UILabel()
            label.text = "Pull to load more..."
            label.font = .systemFont(ofSize: 14)
            label.textColor = .secondaryLabel
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            
            footerView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
            ])
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (isLoadingMore || canLoadMore) ? 60 : 0
    }
    
}
