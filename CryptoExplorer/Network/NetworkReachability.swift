//
//  NetworkReachability.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 06/12/24.
//

import Network

/// Protocol defining the contract for checking network reachability.
protocol ReachabilityProtocol {
    /// Checks if the network is currently reachable.
    /// - Returns: A Boolean value indicating whether the network is reachable.
    func isReachable() -> Bool
}

/// A class for monitoring network reachability status using `NWPathMonitor`.
/// - Provides a singleton instance for global reachability checks.
/// - Updates the network status asynchronously whenever the connection state changes.
class NetworkReachability: ReachabilityProtocol {
    /// Shared singleton instance for global access.
    static let shared = NetworkReachability()

    /// Monitor that observes changes in the network's reachability status.
    private let monitor = NWPathMonitor()

    /// Dispatch queue for handling path updates in the background.
    private let queue = DispatchQueue.global(qos: .background)

    /// Stores the current reachability status. Defaults to `true`.
    private var reachable: Bool = true

    /// Private initializer to enforce singleton pattern.
    private init() {
        monitor.pathUpdateHandler = { path in
            self.reachable = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }

    /// Checks if the network is currently reachable.
    /// - Returns: A Boolean value indicating whether the network is reachable.
    func isReachable() -> Bool {
        return reachable
    }
}


