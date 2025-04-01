import SwiftUI

struct AchiveView: View {
    // Состояние для хранения данных о достижениях
    @State private var achievements: [Achievement] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding()
                            .onTapGesture {
                                NavGuard.shared.currentScreen = .MENU
                            }
                        Spacer()
                    }
                    Spacer()
                }
                
                VStack {
                    Image("achive1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 150)
                    
                    Image("achive2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 150)
                    
                    Image("achive3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 150)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image("backgroundAchive")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
            .onAppear {
                // Загрузка данных о достижениях
                loadAchievements()
            }
        }
    }
    
    // Функция загрузки данных о достижениях
    private func loadAchievements() {
        // Имитация асинхронной загрузки данных
        DispatchQueue.global().async {
            let mockData = [
                Achievement(id: 1, title: "First Steps", description: "Complete your first level.", isUnlocked: true),
                Achievement(id: 2, title: "Master of Levels", description: "Complete 10 levels.", isUnlocked: false),
                Achievement(id: 3, title: "Speed Runner", description: "Finish a level in under 2 minutes.", isUnlocked: false)
            ]
            
            // Обновляем состояние после загрузки
            DispatchQueue.main.async {
                achievements = mockData
            }
        }
    }
}

// Модель данных для достижений
struct Achievement: Identifiable {
    let id: Int
    let title: String
    let description: String
    var isUnlocked: Bool
}

#Preview {
    AchiveView()
}
