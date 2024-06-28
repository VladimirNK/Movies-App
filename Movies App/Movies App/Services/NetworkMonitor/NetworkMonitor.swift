//
//  NetworkMonitor.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 27.06.2024.
//

import Foundation
import Combine
import SystemConfiguration

final class NetworkStatusMonitor: ObservableObject {
    
    //MARK: - Properties
    
    @Published private(set) var isNetworkAvailable: Bool = true
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Init
    
    init() {
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .map { [weak self] _ in self?.checkInternetConnectivity() ?? false }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: \.isNetworkAvailable, on: self)
            .store(in: &cancellables)
    }
    
    //MARK: - Methods
    
    private func checkInternetConnectivity() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return isReachable && !needsConnection
    }
}







