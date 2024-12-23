import Network
import Combine

protocol ConnectionChecker {
    var isConnected: Bool { get }
}

final class NetworkChecker: ConnectionChecker {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ConnectionCheckerQueue")

    private let _isConnectedPublisher = CurrentValueSubject<Bool, Never>(false)
    private(set) lazy var isConnectedPublisher: AnyPublisher<Bool, Never> = _isConnectedPublisher.eraseToAnyPublisher()

    var isConnected: Bool { _isConnectedPublisher.value }

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?._isConnectedPublisher.send(path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
}
