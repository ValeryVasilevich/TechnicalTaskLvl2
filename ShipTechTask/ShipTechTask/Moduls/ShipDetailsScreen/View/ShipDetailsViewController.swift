import UIKit
import Combine

fileprivate enum Constants {
    static let title = "Ship Details"
    static let errorAlertTitle = "Oops!"
    static let roleTitle = "Role:"

    static let placeholderImage = UIImage(named: "placeholder")

    static let stackViewSpacing: CGFloat = 8.0
    static let stackViewInsets: CGFloat = 16.0
    static let roleStackViewInsets: CGFloat = 4.0
    static let imageHeight: CGFloat = 200.0
}

final class ShipDetailsViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: ShipDetailsViewModel
    private var cancellables: Set<AnyCancellable> = []

    private let shipImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel = UILabel()
    private let typeLabel = UILabel()
    private let builtYearLabel = UILabel()
    private let weightLabel = UILabel()
    private let homePortLabel = UILabel()

    private lazy var rolesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.roleStackViewInsets
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.stackViewSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Initializer

    init(viewModel: ShipDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Please use init(viewModel:)")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = Constants.title

        setupLayout()
    }

    private func setupLayout() {
        stackView.addArrangedSubview(shipImageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(typeLabel)
        stackView.addArrangedSubview(builtYearLabel)
        stackView.addArrangedSubview(weightLabel)
        stackView.addArrangedSubview(homePortLabel)
        stackView.addArrangedSubview(rolesStackView)

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.stackViewInsets),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.stackViewInsets),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.stackViewInsets),

            shipImageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight)
        ])
    }

    // MARK: - Bind ViewModel

    private func setupBindings() {
        viewModel.$formattedShipDetails
            .receive(on: DispatchQueue.main)
            .sink { [weak self] formattedDetails in
                self?.updateShipDetails(formattedDetails)
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let errorMessage else { return }
                self?.showErrorAlert(with: errorMessage)
            }
            .store(in: &cancellables)
    }

    // MARK: - Private Methods

    private func updateShipDetails(_ details: ShipDetailsFormatted?) {
        guard let details = details else { return }

        nameLabel.text = details.name
        typeLabel.text = details.type
        builtYearLabel.text = details.builtYear
        weightLabel.text = details.weight
        homePortLabel.text = details.homePort
        loadShipImage(from: details.image)

        updateRolesStackView(with: details.roles)
    }

    private func updateRolesStackView(with roles: [String]) {
        rolesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let roleTitleLabel = UILabel()
        roleTitleLabel.text = Constants.roleTitle
        rolesStackView.addArrangedSubview(roleTitleLabel)

        roles.forEach { role in
            let roleLabel = UILabel()
            roleLabel.text = "- \(role)"
            rolesStackView.addArrangedSubview(roleLabel)
        }
    }

    private func loadShipImage(from imagePath: String?) {
        guard let imagePath = imagePath, let url = URL(string: imagePath) else {
            shipImageView.image = Constants.placeholderImage
            return
        }

        shipImageView.loadImage(from: url)
    }

    private func showErrorAlert(with errorMessage: String) {
        presentAlert(
            title: Constants.errorAlertTitle,
            message: errorMessage
        )
    }
}
