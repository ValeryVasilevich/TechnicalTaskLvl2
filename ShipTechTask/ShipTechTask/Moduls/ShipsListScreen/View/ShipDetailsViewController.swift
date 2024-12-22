import UIKit
import Combine

final class ShipDetailsViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: ShipDetailsViewModel
    private var cancellables: Set<AnyCancellable> = []

    private let nameLabel = UILabel()
    private let typeLabel = UILabel()
    private let builtYearLabel = UILabel()
    private let weightLabel = UILabel()
    private let homePortLabel = UILabel()
    private let rolesLabel = UILabel()

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
        title = "Ship Details"

        setupLayout()
    }

    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, typeLabel, builtYearLabel, weightLabel, homePortLabel, rolesLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Bind ViewModel

    private func setupBindings() {
        viewModel.$ship
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ship in
                guard let ship = ship else { return }
                self?.nameLabel.text = "Ship name: \(ship.name)"
                self?.typeLabel.text = "Ship type: \(ship.type)"
                self?.builtYearLabel.text = "Built year: \(ship.builtYear)"
//                self?.weightLabel.text = "Weight: \(ship.weight) kg"
//                self?.homePortLabel.text = "Home port: \(ship.homePort)"
//                self?.rolesLabel.text = "Roles: \(ship.roles.joined(separator: ", "))"
            }
            .store(in: &cancellables)
    }
}
