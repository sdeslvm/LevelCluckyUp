import SwiftUI

struct CardOption: Identifiable {
    let id: String
    let buyImage: String
    let selectImage: String
    let closeImage: String
    let selectedImage: String
}

struct CustomModalView: View {
    let message: String
    let isPresented: Binding<Bool>
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text(message)
                    .font(.system(size: 20, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                Button(action: {
                    isPresented.wrappedValue = false
                }) {
                    Text("OK")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 120, height: 40)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(red: 0.2, green: 0.2, blue: 0.3))
                    .shadow(radius: 10)
            )
            .padding(.horizontal, 40)
        }
        .transition(.opacity)
    }
}



struct StoreView: View {
    @StateObject private var balanceManager = BalanceManager.shared
    @AppStorage("ownedCards") private var ownedCards: String = "background1" // Используем строку для хранения карт
    @AppStorage("selectedCard") private var selectedCard: String = "firstCardSelected" // Выбранная карта
    @AppStorage("currentSelectedCloseCard") private var currentSelectedCloseCard: String = "background1" 

    @State private var alertMessage: String? // Для хранения текста алерта
    @State private var showAlert: Bool = false // Отображение алерта

    private let cardOptions: [CardOption] = [
        CardOption(id: "firstCard", buyImage: "firstCardBuy", selectImage: "firstCardSelect", closeImage: "background1", selectedImage: "firstCardSelected"),
        CardOption(id: "secondCard", buyImage: "secondCardBuy", selectImage: "secondCardSelect", closeImage: "background2", selectedImage: "secondCardSelected"),
        CardOption(id: "thirdCard", buyImage: "thirdCardBuy", selectImage: "thirdCardSelect", closeImage: "background3", selectedImage: "thirdCardSelected")
    ]
    
    private let cardPrice: Int = 100
    

    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                            BalanceTemplate()
                        }
                        Spacer()
                    }
                    
                    
                    
                    ZStack {
                        VStack(spacing: 20) {
                            ForEach(cardOptions) { card in
                                Button(action: {
                                    handleCardAction(for: card)
                                }) {
                                    Image(currentImage(for: card))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geometry.size.width / 2, height: geometry.size.height / 5)
                                }
                            }
                        }
                        
                        if showAlert {
                            CustomModalView(message: alertMessage ?? "", isPresented: $showAlert)
                                .animation(.easeInOut, value: showAlert)
                        }
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
    
    private func currentImage(for card: CardOption) -> String {
        if card.selectedImage == selectedCard {
            return card.selectedImage // Отображаем "выбранный" статус
        } else if ownedCards.contains(card.closeImage) {
            return card.selectImage // Карта куплена, но не выбрана
        } else {
            return card.buyImage // Карта не куплена
        }
    }
    
    private func handleCardAction(for card: CardOption) {
        if ownedCards.contains(card.closeImage) {
            selectedCard = card.selectedImage
            saveCurrentSelectedCloseCard(card.closeImage)
            alertMessage = "Card selected successfully!"
        } else if balanceManager.playerBalance >= cardPrice {
            balanceManager.playerBalance -= cardPrice
            ownedCards += "," + card.closeImage
            selectedCard = card.selectedImage
            saveCurrentSelectedCloseCard(card.closeImage)
            alertMessage = "Card purchased successfully!"
        } else {
            alertMessage = "Not enough coins to buy this card!"
        }
        showAlert = true
    }
    
    private func saveCurrentSelectedCloseCard(_ closeCard: String) {
        currentSelectedCloseCard = closeCard // Сохраняем в @AppStorage значение closeImage
    }
}


#Preview {
    StoreView()
}


