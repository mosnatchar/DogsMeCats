//
//  CatBreedCell.swift
//  DogMeCat
//
//  Created by Natchar boonmak on 14/11/2568 BE.
//

import UIKit
final class CatBreedCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let expanded = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layoutUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        expanded.image = UIImage(systemName: "arrowtriangle.down.fill")
        expanded.tintColor = .label
        expanded.contentMode = .scaleAspectFit
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)

        detailLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        detailLabel.numberOfLines = 0
        detailLabel.textColor = .secondaryLabel
    }

    private func layoutUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(expanded)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        expanded.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            expanded.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            expanded.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            expanded.widthAnchor.constraint(equalToConstant: 20),
            expanded.heightAnchor.constraint(equalToConstant: 20),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: expanded.leadingAnchor, constant: -8),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func setExpanded(show: Bool) {
        if show {
            expanded.image = UIImage(systemName: "arrowtriangle.down.fill")
        } else {
            expanded.image = UIImage(systemName: "arrowtriangle.up.fill")
        }
    }

    func configure(with item: Cats.Load.ViewModel.BreedItem) {
        titleLabel.text = item.name
        detailLabel.text = item.detailText
        detailLabel.isHidden = !item.isExpanded
        setExpanded(show: !item.isExpanded)
    }
}

