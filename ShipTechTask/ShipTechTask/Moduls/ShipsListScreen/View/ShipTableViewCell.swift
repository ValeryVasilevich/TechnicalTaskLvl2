import UIKit

final class ShipTableViewCell: UITableViewCell {

    // MARK: - UI Elements

    private let shipImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let shipNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let shipTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let builtYearLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
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
            shipImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            shipImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            shipImageView.widthAnchor.constraint(equalToConstant: 80),
            shipImageView.heightAnchor.constraint(equalToConstant: 80),

            shipNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            shipNameLabel.leadingAnchor.constraint(equalTo: shipImageView.trailingAnchor, constant: 16),
            shipNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            shipTypeLabel.topAnchor.constraint(equalTo: shipNameLabel.bottomAnchor, constant: 8),
            shipTypeLabel.leadingAnchor.constraint(equalTo: shipImageView.trailingAnchor, constant: 16),
            shipTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            builtYearLabel.topAnchor.constraint(equalTo: shipTypeLabel.bottomAnchor, constant: 8),
            builtYearLabel.leadingAnchor.constraint(equalTo: shipImageView.trailingAnchor, constant: 16),
            builtYearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            builtYearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Configure

    func configure(with ship: Ship) {
        shipNameLabel.text = ship.name
        shipTypeLabel.text = ship.type
        builtYearLabel.text = ship.builtYear
        shipImageView.image = UIImage(named: "") // TODO: Replace with actual image logic
    }
}
