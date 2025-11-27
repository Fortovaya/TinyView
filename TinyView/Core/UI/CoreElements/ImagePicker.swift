//
//  ImagePicker.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {

	@Binding var images: [UIImage]

	func makeUIViewController(context: Context) -> PHPickerViewController {
		var configuration = PHPickerConfiguration(photoLibrary: .shared())
		configuration.filter = .images
		configuration.selectionLimit = 0 // без лимита

		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = context.coordinator
		return picker
	}

	func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	final class Coordinator: NSObject, PHPickerViewControllerDelegate {

		private let parent: ImagePicker

		init(_ parent: ImagePicker) {
			self.parent = parent
		}

		func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
			picker.dismiss(animated: true)

			guard !results.isEmpty else { return }

			for result in results {
				if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
					result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
						guard let image = object as? UIImage else { return }

						Task {
							let compressed = await ImageCompression.shared.compressIfNeeded(image, maxMB: 20.0)

							DispatchQueue.main.async {
								self.parent.images.append(compressed)
							}
						}
					}
				}
			}
		}
	}
}
