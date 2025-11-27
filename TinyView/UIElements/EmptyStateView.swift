//
//  EmptyStateView.swift
//  TinyView
//
//  Created by Алина on 27.11.2025.
//

import SwiftUI

struct EmptyStateView: View {
	let systemImageName: String?
	let message: String
	let imageSize: CGFloat

	var body: some View {
		VStack(spacing: 16) {
			if let icon = systemImageName {
				Image(systemName: icon)
					.font(.system(size: imageSize))
			}
			Text(message)
				.multilineTextAlignment(.center)
		}
	}
}
