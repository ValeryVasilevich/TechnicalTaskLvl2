import UIKit

fileprivate enum Constants {
    static let placeholderImage = UIImage(named: "placeholder")

    static let shipImageViewCornerRadius: CGFloat = 40.0
    static let shipImageViewSize = CGSize(width: 80.0, height: 80.0)
    static let shipImageViewInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)

    static let shipNameLabelFont = UIFont.boldSystemFont(ofSize: 16)
    static let shipTypeLabelFont = UIFont.systemFont(ofSize: 14)
    static let builtYearLabelFont = UIFont.systemFont(ofSize: 14)
    static let shipLabelTextColor = UIColor.gray

    static let labelSpacing: CGFloat = 8
    static let contentViewEdgeInsets: CGFloat = 16
}

final class ShipTableViewCell: UITableViewCell {

    // MARK: - UI Elements

    private let shipImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.shipImageViewCornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let shipNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.shipNameLabelFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let shipTypeLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.shipTypeLabelFont
        label.textColor = Constants.shipLabelTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let builtYearLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.builtYearLabelFont
        label.textColor = Constants.shipLabelTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI

    private func setupUI() {
        contentView.addSubview(shipImageView)
        contentView.addSubview(shipNameLabel)
        contentView.addSubview(shipTypeLabel)
        contentView.addSubview(builtYearLabel)

        NSLayoutConstraint.activate([
            shipImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.shipImageViewInsets.left),
            shipImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            shipImageView.widthAnchor.constraint(equalToConstant: Constants.shipImageViewSize.width),
            shipImageView.heightAnchor.constraint(equalToConstant: Constants.shipImageViewSize.width),

            shipNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.contentViewEdgeInsets),
            shipNameLabel.leadingAnchor.constraint(equalTo: shipImageView.trailingAnchor, constant: Constants.shipImageViewInsets.right),
            shipNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentViewEdgeInsets),

            shipTypeLabel.topAnchor.constraint(equalTo: shipNameLabel.bottomAnchor, constant: Constants.labelSpacing),
            shipTypeLabel.leadingAnchor.constraint(equalTo: shipImageView.trailingAnchor, constant: Constants.shipImageViewInsets.right),
            shipTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentViewEdgeInsets),

            builtYearLabel.topAnchor.constraint(equalTo: shipTypeLabel.bottomAnchor, constant: Constants.labelSpacing),
            builtYearLabel.leadingAnchor.constraint(equalTo: shipImageView.trailingAnchor, constant: Constants.shipImageViewInsets.right),
            builtYearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentViewEdgeInsets),
            builtYearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.contentViewEdgeInsets)
        ])
    }

    // MARK: - Configure

    func configure(with ship: Ship) {
        shipNameLabel.text = ship.name
        shipTypeLabel.text = ship.type
        builtYearLabel.text = ship.builtYear
        if let imageUrlString = ship.image, let url = URL(string: imageUrlString) {
            shipImageView.loadImage(from: url)
        } else {
            shipImageView.image = Constants.placeholderImage
        }
    }
}
