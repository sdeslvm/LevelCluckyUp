import SwiftUI

struct MenuView: View {
    

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                VStack {
                    ButtonTemplateBig(image: "playBtn", action: {NavGuard.shared.currentScreen = .GAME})
//                    ButtonTemplateBig(image: "settingsBtn", action: {NavGuard.shared.currentScreen = .MENU})
                }
                
                VStack {
                    HStack {
                        ButtonTemplateSmall(image: "shopBtn", action: {NavGuard.shared.currentScreen = .STORE})
                        Spacer()
                        ButtonTemplateSmall(image: "achiveBtn", action: {NavGuard.shared.currentScreen = .ACHIVE})
                    }
                    .padding()
                    Spacer()
                }
                
                
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundMenu)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )

        }
    }
}



struct BalanceTemplate: View {
    @StateObject private var balanceManager = BalanceManager.shared
    
    var body: some View {
        ZStack {
            Image("balanceTemplate")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                        Text("\(balanceManager.playerBalance)")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 85, y: 35)
                    }
                )
        }
    }
}



struct ButtonTemplateSmall: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}

struct ButtonTemplateBig: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 100)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}



#Preview {
    MenuView()
}

