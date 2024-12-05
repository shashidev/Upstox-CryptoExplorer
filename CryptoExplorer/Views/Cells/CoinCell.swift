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

    private let typeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let tagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true 
        return imageView
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
        contentView.addSubview(typeImageView)

        typeImageView.addSubview(tagImageView)

        // Auto Layout Constraints
        NSLayoutConstraint.activate([
            // Name Label
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            // Symbol Label
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            symbolLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // Type Image View
            typeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            typeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            typeImageView.widthAnchor.constraint(equalToConstant: 32),
            typeImageView.heightAnchor.constraint(equalToConstant: 32),

            // Adjust spacing
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: typeImageView.leadingAnchor, constant: -8),

            // Tag Image View (small icon at the top-right corner)
            tagImageView.topAnchor.constraint(equalTo: typeImageView.topAnchor, constant: -8),
            tagImageView.trailingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 4),
            tagImageView.widthAnchor.constraint(equalToConstant: 14),
            tagImageView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }


    // MARK: - Configure Cell
    func configure(with coin: CryptoCoin) {
        nameLabel.text = coin.name
        symbolLabel.text = coin.symbol

        let isActive = coin.isActive ?? false

        let imageName: String
        switch coin.type {
        case Constants.CoinType.coin:
            imageName = isActive ? ImageConstants.activeCoin : ImageConstants.inactiveToken
        case Constants.CoinType.token:
            imageName = isActive ? ImageConstants.activeToken : ImageConstants.inactiveToken
        default:
            imageName = isActive ? ImageConstants.inactiveCoin : String.empty
        }

        typeImageView.image = UIImage(named: imageName)

        // Configure the tagImageView for new coins
        tagImageView.isHidden = !coin.isNew
        if coin.isNew {
            tagImageView.image = UIImage(named: ImageConstants.newTag)
        }

        nameLabel.textColor = coin.isActive ?? false ? .black : .lightGray
        symbolLabel.textColor = coin.isActive ?? false ? .darkGray : .lightGray
        contentView.alpha = coin.isActive ?? false ? 1.0 : 0.5
    }
}

