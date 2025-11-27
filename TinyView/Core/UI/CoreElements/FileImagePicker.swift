//
//  FileImagePicker.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct FileImagePicker: UIViewControllerRepresentable {

	@Binding var images: [UIImage]

	func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
		let types: [UTType] = [.image]
		let picker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
		picker.delegate = context.coordinator
		picker.allowsMultipleSelection = true
		return picker
	}

	func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	final class Coordinator: NSObject, UIDocumentPickerDelegate {

		private let parent: FileImagePicker

		init(_ parent: FileImagePicker) {
			self.parent = parent
		}

		func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
			guard !urls.isEmpty else { return }

			Task {
				await processUrls(urls)
			}
		}

		private func processUrls(_ urls: [URL]) async {
			for url in urls {
				guard url.startAccessingSecurityScopedResource() else { continue }
				defer { url.stopAccessingSecurityScopedResource() }

				if let data = try? Data(contentsOf: url),
				   let image = UIImage(data: data) {

					let compressed = await ImageCompression.shared.compressIfNeeded(image, maxMB: 20.0)

					await MainActor.run {
						self.parent.images.append(compressed)
					}
				}
			}
		}
	}
}
