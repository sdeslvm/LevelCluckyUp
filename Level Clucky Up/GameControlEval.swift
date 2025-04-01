import Foundation
import WebKit

class GameControl: NSObject, WKNavigationDelegate {
    let owner: Renderer
    var redirectFlag = false
  
    init(owner: Renderer) {
        self.owner = owner
        debugPrint("Control init")
    }
    
    private func updateState(_ state: LoaderStateGame) {
        DispatchQueue.main.async { [weak self] in
            self?.owner.vm.loaderState = state
        }
    }
    
    func webView(_ wv: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        debugPrint("StartNav: \(wv.url?.absoluteString ?? "n/a")")
        if !redirectFlag { updateState(.loading(progress: 0.0)) }
    }
    
    func webView(_ wv: WKWebView, didCommit _: WKNavigation!) {
        redirectFlag = false
        debugPrint("CommitNav: \(Int(wv.estimatedProgress * 100))%")
    }
    
    func webView(_ wv: WKWebView, didFinish _: WKNavigation!) {
        debugPrint("EndNav: \(wv.url?.absoluteString ?? "n/a")")
        updateState(.loaded)
    }
    
    func webView(_ wv: WKWebView, didFail _: WKNavigation!, withError e: Error) {
        debugPrint("FailNav: \(e)")
        updateState(.failed(e))
    }
    
    func webView(_ wv: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError e: Error) {
        debugPrint("ProvFailNav: \(e)")
        updateState(.failed(e))
    }
    
    func webView(_ wv: WKWebView, decidePolicyFor action: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if action.navigationType == .other && wv.url != nil {
            redirectFlag = true
            debugPrint("RedirNav: \(action.request.url?.absoluteString ?? "n/a")")
        }
        decisionHandler(.allow)
    }
}
