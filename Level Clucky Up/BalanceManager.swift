import SwiftUI

class BalanceManager: ObservableObject {
    static let shared = BalanceManager()
    
    @AppStorage("coinscore") var playerBalance: Int = 10
    private var timer: Timer?
    
    private init() {
        startCoinGeneration()
    }
    
    private func startCoinGeneration() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.addCoin()
        }
    }
    
    private func addCoin() {
        playerBalance += 1
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
} 
