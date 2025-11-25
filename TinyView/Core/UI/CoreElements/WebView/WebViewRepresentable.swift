//
//  WebViewRepresentable.swift
//  TinyView
//
//  Created by Алина on 25.11.2025.
//

import SwiftUI
import WebKit

struct WebViewRepresentable: UIViewRepresentable {
	let url: URL
	let isAppearenceEnabled: Bool

	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}

	func makeUIView(context: Context) -> WKWebView {
		let webView = WKWebView()
		webView.navigationDelegate = context.coordinator
		return webView
	}

	func updateUIView(_ uiView: WKWebView, context: Context) {
		uiView.load(URLRequest(url: url))
	}

	class Coordinator: NSObject, WKNavigationDelegate {
		private let parent: WebViewRepresentable

		init(parent: WebViewRepresentable) {
			self.parent = parent
		}
		func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
			guard parent.isAppearenceEnabled else { return }
			let isDark = webView.traitCollection.userInterfaceStyle == .dark

			let jsCode = """
   if ('\(isDark)' === 'true') {
   document.documentElement.style.filter = 'invert(1) hue-rotate(180deg)';
   document.addEventListener('click', function(event) {
   event.stopPropagation();
   event.preventDefault();
   }, true);
   }
   """
			webView.evaluateJavaScript(jsCode, completionHandler: { _, error in
				if let error {
					print("JavaScript error: \(error.localizedDescription)")
				}
			})
		}
	}
}

extension WebViewRepresentable.Coordinator {
	func webView(
		_ webView: WKWebView,
		decidePolicyFor navigationAction: WKNavigationAction,
		decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
	) {
		if navigationAction.navigationType == .other {
			decisionHandler(.allow)
		} else {
			decisionHandler(.cancel)
		}
	}
}
