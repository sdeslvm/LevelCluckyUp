import SwiftUI

struct GameScreen: View {
    @AppStorage("currentSelectedCloseCard") private var currentSelectedCloseCard: String = "background1"
    


    
    
    let background1 = "https://chickensfarmcrash.top/gaming1/"
    let background2 = "https://chickensfarmcrash.top/gaming2/"
    let background3 = "https://chickensfarmcrash.top/gaming3/"
    
    // Вычисляемый URL на основе currentSelectedCloseCard
    var currentURL: URL {
        switch currentSelectedCloseCard {
        case "background1":
            return URL(string: background1)!
        case "background2":
            return URL(string: background2)!
        case "background3":
            return URL(string: background3)!
        default:
            return URL(string: background1)! // По умолчанию background1
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Нижний слой: GameLoaderHelper
                GameLoaderHelper(ctrl: .init(url: currentURL)) // Используем currentURL
                    .background(Color(hex: "#1f3144").ignoresSafeArea())
                    .zIndex(0) // Указываем низкий приоритет
                
                // Верхний слой: Интерфейсные элементы
                VStack {
                    HStack {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding()
                            .onTapGesture {
                                NavGuard.shared.currentScreen = .MENU
                            }
                        Spacer()
                    }
                    Spacer()
                }
                .zIndex(1) // Указываем высокий приоритет
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

#Preview {
    GameScreen()
}
