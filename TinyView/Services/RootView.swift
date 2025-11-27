//
//  RootView.swift
//  TinyView
//
//  Created by Алина on 25.11.2025.
//

import SwiftUI

struct RootView: View {
	@AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

	var body: some View {
		NavigationView {
			if hasCompletedOnboarding {
				MainView()
			} else {
				WelcomeScreenView(hasCompletedOnboarding: $hasCompletedOnboarding)
			}
		}
		.navigationViewStyle(.stack)
	}
}
