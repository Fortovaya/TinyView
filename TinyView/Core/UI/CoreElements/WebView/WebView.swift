//
//  WebView.swift
//  TinyView
//
//  Created by Алина on 25.11.2025.
//

import SwiftUI

struct WebView: View {
	@Environment(\.dismiss) var dismiss
	let url: URL
	let isAppearenceEnabled: Bool

	init(
		url: URL,
		isAppearenceEnabled: Bool = false
	) {
		self.url = url
		self.isAppearenceEnabled = isAppearenceEnabled
	}

	var body: some View {
		WebViewRepresentable(url: url, isAppearenceEnabled: isAppearenceEnabled)
			.ignoresSafeArea(edges: .bottom)
			.navigationBarBackButtonHidden(true)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						dismiss()
					} label: {
						Image(systemName: "chevron.left")
							.foregroundStyle(.black)
					}
				}
			}
	}
}

#Preview {
	guard let url = URL(string: "https://aezakmi.group/") else {
		return Text("Неверный URL")
	}
	return WebView(url: url, isAppearenceEnabled: true)
}
