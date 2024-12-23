import UIKit
import Combine

fileprivate enum Constants {
    static let titleText = "Ships"
    static let offlineBannerText = "No internet connection. You're in Offline mode"
    static let offlineBannerHeight: CGFloat = 44.0
}

final class ShipListViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: ShipsListViewModel
    private var cancellables: Set<AnyCancellable> = []

    private lazy var shipsTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(cellClass: ShipTableViewCell.self)
        tableView.refreshControl = refreshControl
        return tableView
    }()

    private let offlineBanner: UILabel = {
        let label = UILabel()
        label.text = Constants.offlineBannerText
        label.textAlignment = .center
        label.backgroundColor = .systemRed
        label.textColor = .white
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()

    // MARK: - Initializer

    init(viewModel: ShipsListViewModel) {
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
        title = Constants.titleText
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
            offlineBanner.heightAnchor.constraint(equalToConstant: Constants.offlineBannerHeight),

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
                self?.shipsTableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)

        viewModel.$isOfflineMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isOffline in
                self?.offlineBanner.isHidden = !isOffline
                // TODO: - the banner height is set to 0 here, if there is an Internet connection, here is the off-line Banner Height
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    @objc private func refreshData() {
        Task {
            await viewModel.fetchShips()
        }
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ship = viewModel.ships[indexPath.row]
        
        viewModel.didSelectShip?(ship.id)
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
