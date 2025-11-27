//
//  TinyViewApp.swift
//  TinyView
//
//  Created by Алина on 25.11.2025.
//

import SwiftUI

@main
struct TinyViewApp: App {

	init() {
		let tabAppearance = UITabBarAppearance()
		tabAppearance.configureWithOpaqueBackground()
		tabAppearance.backgroundColor = .systemBackground
		tabAppearance.shadowColor = .clear
		UITabBar.appearance().standardAppearance = tabAppearance
		UITabBar.appearance().scrollEdgeAppearance = tabAppearance

		let navAppearance = UINavigationBarAppearance()
		navAppearance.configureWithOpaqueBackground()
		navAppearance.backgroundColor = .systemBackground
		navAppearance.shadowColor = .clear
		navAppearance.shadowImage = UIImage()
		UINavigationBar.appearance().standardAppearance = navAppearance
		UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
		UINavigationBar.appearance().compactAppearance = navAppearance
	}

    var body: some Scene {
        WindowGroup {
			RootView()
        }
    }
}
