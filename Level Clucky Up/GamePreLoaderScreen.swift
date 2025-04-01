import SwiftUI
import WebKit
import Foundation

class LoaderVM: ObservableObject {
    @Published var loaderState: LoaderStateGame = .idle
    let url: URL
    private var wv: WKWebView?
    private var regr: NSKeyValueObservation?
    private var progreess: Double = 0.0
   
    
    init(url: URL) {
        self.url = url
        debugPrint("Model initialized with URL: \(url)")
    }
    
    func setWebView(_ webView: WKWebView) {
        self.wv = webView
        observeProgress(webView)
        loadRequest()
        debugPrint("WebView set in Model")
    }
    
    func loadRequest() {
        guard let webView = wv else {
            debugPrint("WebView is nil, cannot load yet")
            return
        }
        let request = URLRequest(url: url, timeoutInterval: 15.0)
        debugPrint("Loading request for URL: \(url)")
       
        DispatchQueue.main.async { [weak self] in
            self?.loaderState = .loading(progress: 0.0)
            self?.progreess = 0.0
        }
        webView.load(request)
    }
    
    private func observeProgress(_ webView: WKWebView) {
        regr = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            let progress = webView.estimatedProgress
            debugPrint("Progress updated: \(Int(progress * 100))%")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if progress > self.progreess {
                    self.progreess = progress
                    self.loaderState = .loading(progress: self.progreess)
                }
                if progress >= 1.0 {
                    self.loaderState = .loaded
                }
            }
        }
    }
    
    func updateNetworkStatus(_ isConnected: Bool) {
        if isConnected && loaderState == .noInternet {
            loadRequest()
        } else if !isConnected {
            DispatchQueue.main.async { [weak self] in
                self?.loaderState = .noInternet
            }
        }
       
    }
}

enum LoaderStateGame: Equatable {
    case idle
    case loading(progress: Double)
    case loaded
    case failed(Error)
    case noInternet
    
    static func == (lhs: LoaderStateGame, rhs: LoaderStateGame) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loaded, .loaded), (.noInternet, .noInternet):
            return true
        case (.loading(let lp), .loading(let rp)):
            return lp == rp
        case (.failed, .failed):
            return true
        default:
            return false
        }
    }
}

struct Renderer: UIViewRepresentable {
    @ObservedObject var vm: LoaderVM
    
    func makeCoordinator() -> GameControl {
        GameControl(owner: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        // Настройка для отключения кэширования
        config.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        
        let view = WKWebView(frame: .zero, configuration: config)
        
        // Set the background color to #141f2b
        view.backgroundColor = UIColor(hex: "#141f2b")
        view.isOpaque = false // Optional: Ensures the background color is fully applied
        
        // Очистка всех существующих данных кэша
        let dataTypes = Set([WKWebsiteDataTypeDiskCache,
                           WKWebsiteDataTypeMemoryCache,
                           WKWebsiteDataTypeCookies,
                           WKWebsiteDataTypeLocalStorage])
        
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes,
                                              modifiedSince: Date.distantPast) {
            debugPrint("Cache cleared on creation")
        }
        
        debugPrint("Renderer: \(vm.url)")
        view.navigationDelegate = context.coordinator
        vm.setWebView(view)
        return view
    }
    
    func updateUIView(_ view: WKWebView, context: Context) {
        // Очистка кэша при обновлении представления
        let dataTypes = Set([WKWebsiteDataTypeDiskCache,
                           WKWebsiteDataTypeMemoryCache,
                           WKWebsiteDataTypeCookies,
                           WKWebsiteDataTypeLocalStorage])
        
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes,
                                              modifiedSince: Date.distantPast) {
            debugPrint("Cache cleared on update")
        }
        
        debugPrint("RendererUpdate: \(view.url?.absoluteString ?? "nil")")
    }
}

// UIColor extension to handle hex color codes
extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

