import Foundation


enum AvailableScreens {
    case MENU
    case ACHIVE
    case STORE
//    case ACHIVE
//    case SETTINGS
    case GAME
}

class NavGuard: ObservableObject {
    @Published var currentScreen: AvailableScreens = .MENU
    static var shared: NavGuard = .init()
}
