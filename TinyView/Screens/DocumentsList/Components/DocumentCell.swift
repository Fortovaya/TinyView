//
//  DocumentCell.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import SwiftUI

struct DocumentCell: View {
	let document: StoredPDFModel

	var body: some View {
		HStack(spacing: 12) {
			thumbnailView
			textContent
			Spacer()
		}
		.padding(.vertical, 4)
		.frame(height: 80, alignment: .center)
	}

	private var thumbnailView: some View {
		Group {
			if let thumbnail = document.thumbnail {
				Image(uiImage: thumbnail)
					.resizable()
					.scaledToFill()
					.frame(width: 50, height: 70)
					.clipShape(RoundedRectangle(cornerRadius: 8))
			} else {
				placeholderView
			}
		}
	}

	private var textContent: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(document.name)
				.font(.headline)
				.lineLimit(1)
			HStack {
				Text(".\(document.fileExtension)")
				Text(document.formattedDate)
			}
			.foregroundColor(.gray)
			.font(.caption)
		}
		.padding(.vertical, 8)
	}

	private var placeholderView: some View {
		RoundedRectangle(cornerRadius: 8)
			.fill(Color.gray.opacity(0.3))
			.frame(width: 50, height: 70)
			.overlay(
				Image(systemName: "doc")
					.foregroundColor(.gray)
			)
	}
}
