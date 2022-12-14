//
//  AppState.swift
//  OpenAI
//
//  Created by Ingo Boehme on 13.12.22.
//

import Foundation
import Network
import SwiftUI

class AppState: ObservableObject {
    @Published var isOffline: Bool = true
    @AppStorage("tab") var selectedTab = 0

    init() {
        setupInternetMonitoring()
        #warning("Dont forget to make that more smooth")
    }

    
    // TODO: - Something is missing
    // FIXME: Fix this one here
    // ???: WTF is going on here
    // !!!: That's the clou
    // MARK: - Checking Internet Connectivity -
    private var monitor = NWPathMonitor()

    func setupInternetMonitoring() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                // FIXME: Fix and simplify this one here
                if path.status == .satisfied {
                    self.isOffline = false
                } else {
                    self.isOffline = true
                }
            }
        }

        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }

    public func stopInternetMonitoring() {
        monitor.cancel()
    }
}
