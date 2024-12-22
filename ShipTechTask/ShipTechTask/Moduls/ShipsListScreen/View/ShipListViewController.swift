import UIKit
import Combine

final class ShipListViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: ShipListViewModel
    private var cancellables: Set<AnyCancellable> = []

    private lazy var shipsTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(cellClass: ShipTableViewCell.self)
    }()

    private let offlineBanner: UILabel = {
        let label = UILabel()
        label.text = "No internet connection. You're in Offline mode"
        label.textAlignment = .center
        label.backgroundColor = .systemRed
        label.textColor = .white
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
    }()

    // MARK: - Initializer

    init(viewModel: ShipListViewModel) {
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

        Task {
            await viewModel.fetchShips()
        }
    }

    // MARK: - UI Setup

    private func setupUI() {
        title = "Ships"
        view.backgroundColor = .systemBackground

        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(shipsTableView)
        view.addSubview(offlineBanner)

        NSLayoutConstraint.activate([
            offlineBanner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            offlineBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            offlineBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            offlineBanner.heightAnchor.constraint(equalToConstant: 44),

            shipsTableView.topAnchor.constraint(equalTo: offlineBanner.bottomAnchor),
            shipsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shipsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shipsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Bind ViewModel

    private func setupBindings() {
        viewModel.$ships
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.shipsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
            .store(in: &cancellables)

        viewModel.$isOfflineMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isOffline in
                self?.offlineBanner.isHidden = !isOffline
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ShipListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.ships.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShipTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let ship = viewModel.ships[indexPath.row]
        cell.configure(with: ship)

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ship = viewModel.ships[indexPath.row]
            Task {
                await viewModel.deleteShip(by: ship.id)
            }
        }
    }
}
