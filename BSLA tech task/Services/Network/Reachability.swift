//
//  Reachability.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 10/1/24.
//

import Foundation
import Network

protocol NetworkReachabilityRepo {
    var isReachableOnCellular: Bool {get}
    
    func changeRechability(reachable: Bool)
}

extension NetworkReachabilityRepo {
    func changeRechability(reachable: Bool) {}
}

class NetworkReachability: NetworkReachabilityRepo {
    static let shared = NetworkReachability()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private var isMonitoring = false
    
    var isReachable: Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    var isReachableOnCellular: Bool {
        return monitor.currentPath.isExpensive
    }
    
    // MARK: - init
    private init() {
        startMonitoring()
    }
    
    // MARK: - deinit
    deinit {
        stopMonitoring()
    }
    
    
    // MARK: - logic
    func startMonitoring() {
        guard !isMonitoring else { return }
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] _ in
            self?.notifyNetworkStatus()
        }
        isMonitoring = true
    }
    
    func stopMonitoring() {
        guard isMonitoring else { return }
        monitor.cancel()
        isMonitoring = false
    }
    
    private func notifyNetworkStatus() {
        print("reachability", isReachable, isReachableOnCellular)
        if isReachable {
            NotificationCenter.default.post(name: .networkReachable, object: nil)
        } else {
            NotificationCenter.default.post(name: .networkNotReachable, object: nil)
        }
    }
}

extension Notification.Name {
    static let networkReachable = Notification.Name("NetworkReachable")
    static let networkNotReachable = Notification.Name("NetworkNotReachable")
}
