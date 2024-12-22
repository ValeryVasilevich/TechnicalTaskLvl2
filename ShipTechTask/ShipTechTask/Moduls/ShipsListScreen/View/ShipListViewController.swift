import UIKit
import Combine

final class ShipListViewController: UIViewController {

    // MARK: - Properties

    private let tableView = UITableView()
    private let offlineBanner = UILabel()
    private let viewModel: ShipListViewModel
    private var cancellables: Set<AnyCancellable> = []

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
        bindViewModel()
        viewModel.fetchShips()
    }

    // MARK: - UI Setup

    private func setupUI() {
        title = "Ships"
        view.backgroundColor = .systemBackground

        // TableView
        tableView.register(ShipTableViewCell.self, forCellReuseIdentifier: ShipTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        // Offline Banner
        offlineBanner.text = "No internet connection. You're in Offline mode"
        offlineBanner.textAlignment = .center
        offlineBanner.backgroundColor = .systemRed
        offlineBanner.textColor = .white
        offlineBanner.isHidden = true
        offlineBanner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(offlineBanner)

        NSLayoutConstraint.activate([
            offlineBanner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            offlineBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            offlineBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            offlineBanner.heightAnchor.constraint(equalToConstant: 44),

            tableView.topAnchor.constraint(equalTo: offlineBanner.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Bind ViewModel

    private func bindViewModel() {
        viewModel.$ships
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
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
            viewModel.deleteShip(by: ship.id)
        }
    }
}
