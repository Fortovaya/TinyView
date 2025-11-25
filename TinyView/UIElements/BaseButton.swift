//
//  BaseButton.swift
//  TinyView
//
//  Created by Алина on 25.11.2025.
//

import SwiftUI

struct BaseButton: View {
	var isActive: Bool = true
	let title: String
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			Text(title)
				.font(.Headline.medium)
				.foregroundStyle(isActive ? Color.white : Color.green)
				.frame(maxWidth: .infinity)
				.padding(.vertical, 12)
				.padding(.horizontal, 20)
				.background(isActive ? Color.green : Color.gray)
				.clipShape(RoundedRectangle(cornerRadius: 100))
		}
		.contentShape(RoundedRectangle(cornerRadius: 100))
		.disabled(!isActive)
	}
}
