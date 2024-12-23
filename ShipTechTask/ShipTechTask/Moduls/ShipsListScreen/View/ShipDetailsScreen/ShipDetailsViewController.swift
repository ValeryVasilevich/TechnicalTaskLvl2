import UIKit
import Combine

final class ShipDetailsViewController: UIViewController {

    // MARK: - Constants

    fileprivate enum Constants {
        static let title = "Ship Details"
        static let stackViewSpacing: CGFloat = 8
        static let stackViewInsets: CGFloat = 16
    }

    // MARK: - Properties

    private let viewModel: ShipDetailsViewModel
    private var cancellables: Set<AnyCancellable> = []

    private let nameLabel = UILabel()
    private let typeLabel = UILabel()
    private let builtYearLabel = UILabel()
    private let weightLabel = UILabel()
    private let homePortLabel = UILabel()

    private lazy var rolesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
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
        fatalError("init(coder:) has not been implemented")
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
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.stackViewInsets)
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

        rolesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let roleTittleLabel = UILabel()
        roleTittleLabel.text = "Role:"

        rolesStackView.addArrangedSubview(roleTittleLabel)
        details.roles.forEach { role in
            let roleLabel = UILabel()
            roleLabel.text = role
            roleLabel.font = UIFont.systemFont(ofSize: 16)
            rolesStackView.addArrangedSubview(roleLabel)
        }
    }

    private func showErrorAlert(with errorMessage: String) {
        presentAlert(
            title: "Oops!",
            message: errorMessage
        )
    }
}
