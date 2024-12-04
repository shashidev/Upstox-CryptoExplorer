//
//  CryptoListViewController.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 02/12/24.
//

import UIKit

class CryptoListViewController: UIViewController {

    private let viewModel = CryptoViewModel()
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let filterView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchCryptoCoins()
    }

    private func setupUI() {
        view.backgroundColor = .gray
        title = "Crypto Coins"

        // Search Bar
        searchBar.delegate = self
        searchBar.placeholder = "Search by name or symbol"
        navigationItem.titleView = searchBar

        // Table View
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        // Register the CoinCell class with the table view
           tableView.register(CoinCell.self, forCellReuseIdentifier: CoinCell.reuseIdentifier)
        view.addSubview(tableView)

        // Filter View
        setupFilterView()
    }

    private func setupFilterView() {
        filterView.backgroundColor = .gray
        filterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterView)

        // Add buttons to the filter view
        let activeFilterButton = createFilterButton(title: "Active", action: #selector(filterActive))
        let typeFilterButton = createFilterButton(title: "Type", action: #selector(filterType))
        let newFilterButton = createFilterButton(title: "New", action: #selector(filterNew))

        let stackView = UIStackView(arrangedSubviews: [activeFilterButton, typeFilterButton, newFilterButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        filterView.addSubview(stackView)

        // Constraints for filterView
        NSLayoutConstraint.activate([
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            filterView.heightAnchor.constraint(equalToConstant: 60),

            stackView.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: filterView.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: filterView.centerYAnchor)
        ])

        // Adjust table view constraints to avoid overlapping with the filter view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: filterView.topAnchor)
        ])
    }

    private func createFilterButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    // Filter Actions
    @objc private func filterActive() {
        viewModel.filterCoins(isActive: true)
    }

    @objc private func filterType() {
        // For demonstration, filtering for a fixed type
        let coinType = "crypto"
        viewModel.filterCoins(type: coinType)
    }

    @objc private func filterNew() {
        viewModel.filterCoins(isNew: true)
    }

    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}


extension CryptoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCoins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the cell using the static reuse identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.reuseIdentifier, for: indexPath) as? CoinCell else {
            return UITableViewCell()
        }

        let coin = viewModel.filteredCoins[indexPath.row]
        cell.configure(with: coin)
        return cell
    }
}

extension CryptoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchCoins(query: searchText)
    }
}




