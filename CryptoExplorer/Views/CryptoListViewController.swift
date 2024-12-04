//
//  CryptoListViewController.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 02/12/24.
//

import UIKit

class CryptoListViewController: UIViewController {

    // MARK: - UI Elements
    private let viewModel = CryptoViewModel()
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private var filterView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .gray)

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = UIConstants.emptyStateMessage
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: UIConstants.emptyStateFontSize)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchCryptoCoins()
    }

    private func setupUI() {
        view.backgroundColor = UIConstants.backgroundColor
        title = Constants.ViewControllerTitles.cryptoCoins

        setupSearchBar()
        setupActivityIndicator()
        setupBottomFilterView()
        setupTableView()
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = Constants.ViewControllerTitles.searchBarPlaceholder
        navigationItem.titleView = searchBar
    }

    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupTableView() {
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIConstants.tableViewBackgroundColor
        tableView.register(CoinCell.self, forCellReuseIdentifier: CoinCell.reuseIdentifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: filterView.topAnchor)
        ])
    }

    private func setupBottomFilterView() {
        let bottomFilterView = UIView()
        bottomFilterView.backgroundColor = UIConstants.filterViewBackgroundColor
        view.addSubview(bottomFilterView)
        bottomFilterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomFilterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomFilterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomFilterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomFilterView.heightAnchor.constraint(equalToConstant: 120)
        ])
        self.filterView = bottomFilterView

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        bottomFilterView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: bottomFilterView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: bottomFilterView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: bottomFilterView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomFilterView.bottomAnchor, constant: -16)
        ])

        let firstRow = createButtonRow(titles: Constants.Titles.firstRowTitles)
        let secondRow = createButtonRow(titles: Constants.Titles.secondRowTitles)

        stackView.addArrangedSubview(firstRow)
        stackView.addArrangedSubview(secondRow)
    }

    private func createButtonRow(titles: [String]) -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.alignment = .fill
        rowStackView.distribution = .fillEqually
        rowStackView.spacing = 8

        for title in titles {
            let button = createFilterButton(title: title)
            button.addTarget(self, action: #selector(handleBottomFilterButton(_:)), for: .touchUpInside)
            rowStackView.addArrangedSubview(button)
        }

        return rowStackView
    }

    private func createFilterButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(UIConstants.buttonTextColor, for: .normal)
        button.backgroundColor = UIConstants.buttonBackgroundColor
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.tag = 0
        button.addTarget(self, action: #selector(handleBottomFilterButton(_:)), for: .touchUpInside)
        return button
    }

    @objc private func handleBottomFilterButton(_ sender: UIButton) {
        sender.tag = sender.tag == 0 ? 1 : 0
        let isSelected = sender.tag == 1

        sender.backgroundColor = isSelected ? UIConstants.buttonSelectedBackgroundColor : UIConstants.buttonBackgroundColor
        sender.setTitleColor(isSelected ? UIConstants.buttonSelectedTextColor : UIConstants.buttonTextColor, for: .normal)

        guard let title = sender.title(for: .normal), let filterType = FilterType(title: title) else {
            return
        }
        filterType.action(isSelected, viewModel)
    }

    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.handleDataUpdate()
            }
        }

        viewModel.onError = { [weak self] in
            DispatchQueue.main.async {
                self?.handleError()
            }
        }
    }

    private func handleDataUpdate() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        tableView.isHidden = false
        viewModel.filteredCoins.isEmpty ? showEmptyStateMessage() : hideEmptyStateMessage()
        tableView.reloadData()
    }

    private func handleError() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        tableView.isHidden = false
        showEmptyStateMessage()
    }

    private func showEmptyStateMessage() {
        tableView.backgroundView = emptyStateLabel
    }

    private func hideEmptyStateMessage() {
        tableView.backgroundView = nil
    }
}

extension CryptoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCoins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

