//
//  CoinCell.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 03/12/24.
//

import UIKit

class CoinCell: UITableViewCell {
    // MARK: - Static Identifier
    static let reuseIdentifier = "CoinCell"

    // MARK: - UI Elements
     let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemBlue
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(typeLabel)

        // Auto Layout Constraints
        NSLayoutConstraint.activate([
            // Name Label
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            // Symbol Label
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            symbolLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // Type Label
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            typeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            typeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor, constant: 8)
        ])
    }

    // MARK: - Configure Cell
    func configure(with coin: CryptoCoin) {
        nameLabel.text = coin.name
        symbolLabel.text = coin.symbol
        typeLabel.text = coin.type

        // Update style for active/inactive coins
        nameLabel.textColor = coin.isActive ?? false ? .black : .lightGray
        symbolLabel.textColor = coin.isActive ?? false ? .darkGray : .lightGray
        contentView.alpha = coin.isActive ?? false ? 1.0 : 0.5
    }
}

