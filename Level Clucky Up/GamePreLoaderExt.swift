import Foundation
import SwiftUI



struct GameLoaderHelper: View {
    @StateObject var mainVM: LoaderVM
    
    init(ctrl: LoaderVM) {
        _mainVM = StateObject(wrappedValue: ctrl)
    }
    
    var body: some View {
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
                        .zIndex(1)
                    Spacer()
                }
                Spacer()
            }
            Renderer(vm: mainVM)
            .opacity(mainVM.loaderState == .loaded ? 1 : 0.5)
            if case .loading(let p) = mainVM.loaderState {
                GeometryReader { geo in
                    LoadingScreen()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .background(Color.black)
                }
            } else if case .failed(let e) = mainVM.loaderState {
                Text("Error: \(e.localizedDescription)").foregroundColor(.red)
            } else if case .noInternet = mainVM.loaderState {
                Text("")
            }
        }
    }
}
