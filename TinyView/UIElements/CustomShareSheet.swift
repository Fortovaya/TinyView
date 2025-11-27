//
//  CustomShareSheet.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import SwiftUI

struct CustomShareSheet: UIViewControllerRepresentable {
	let activityItems: [Any]
	var applicationActivities: [UIActivity]? = nil

	func makeUIViewController(context: Context) -> UIActivityViewController {
		UIActivityViewController(
			activityItems: activityItems,
			applicationActivities: applicationActivities
		)
	}

	func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
