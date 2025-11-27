//
//  View+Extension.swift
//  TinyView
//
//  Created by Алина on 27.11.2025.
//

import SwiftUI

extension View {
	func dismissKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}

	func dismissKeyboardOnTap() -> some View {
		self.background(
			Color.clear
				.contentShape(Rectangle())
				.onTapGesture {
					self.dismissKeyboard()
				}
		)
	}
}
