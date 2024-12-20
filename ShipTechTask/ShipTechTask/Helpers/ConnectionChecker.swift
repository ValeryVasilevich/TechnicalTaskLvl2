import Network
import Combine

protocol ConnectionChecker {
    var isConnected: Bool { get }
}

final class NetworkChecker: ConnectionChecker {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ConnectionCheckerQueue")

    let isConnectedPublisher = CurrentValueSubject<Bool, Never>(false)
    var isConnected: Bool { isConnectedPublisher.value }

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnectedPublisher.send(path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
}
