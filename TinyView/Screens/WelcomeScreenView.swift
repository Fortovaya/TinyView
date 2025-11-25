//
//  WelcomeScreenView.swift
//  TinyView
//
//  Created by Алина on 25.11.2025.
//

import SwiftUI

struct WelcomeScreenView: View {

	@Binding var hasCompletedOnboarding: Bool
	@State private var showInfo = false

	var body: some View {
		VStack {
			VStack(spacing: 60) {
				topTextContent
				imageContent
				headlineContent
			}
			.padding(.top, 20)
			Spacer()
			bottomContent
				.multilineTextAlignment(.center)
				.padding(.bottom, 20)
		}
		.padding(.horizontal, 16)
		.background(Color.pink)
	}

	var topTextContent: some View {
		Text(Strings.header)
			.font(.LargeTitle.regular)
			.lineLimit(1)
			.minimumScaleFactor(0.9)
			.padding(.top, 40)
	}

	var imageContent: some View {
		Image(Strings.image)
			.resizable()
			.scaledToFit()
			.frame(maxWidth: .infinity, maxHeight: 277)
			.padding(.top, 20)
	}

	var headlineContent: some View {
		Text(Strings.headline)
			.font(.Title2.semiBold)
	}

	var bottomContent: some View {
		VStack(spacing: 20) {
			BaseButton(title: Strings.appInfoButtonTitle) {
				showAppInfo()
			}
			BaseButton(title: Strings.buttonTitle) {
				completeOnboarding()
			}
			NavigationLink(
				destination: destinationView,
				isActive: $showInfo
			) {
				EmptyView()
			}
			.hidden()
		}
	}

	@ViewBuilder
	private var destinationView: some View {
		if let url = URL(string: Strings.infoURL) {
			WebView(url: url, isAppearenceEnabled: true)
		} else {
			Text("Некорректный URL")
				.foregroundColor(.red)
		}
	}
}

private extension WelcomeScreenView {
	enum Strings {
		static let header = "Создавай PDF с улыбкой"
		static let headline = "Ваши фото, наше волшебство"
		static let infoURL = "https://fortovaya.github.io/tinyview-app-info/"
		static let buttonTitle = "Стартуем"
		static let image = "welcomeFolder"
		static let appInfoButtonTitle = "Подробнее о приложении"
	}

	func showAppInfo() {
		showInfo = true
	}

	func completeOnboarding() {
		hasCompletedOnboarding = true
	}
}

#Preview {
	NavigationView {
		WelcomeScreenView(hasCompletedOnboarding: .constant(false))
	}
}
