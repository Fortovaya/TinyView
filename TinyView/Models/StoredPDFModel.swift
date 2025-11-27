//
//  StoredPDFModel.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import Foundation
import SwiftUI

struct StoredPDFModel: Identifiable, Hashable {
	let id: UUID
	let name: String
	let fileExtension: String
	let createdAt: Date
	let thumbnail: UIImage?
	let fileURL: URL

	var formattedDate: String {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		return formatter.string(from: createdAt)
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
