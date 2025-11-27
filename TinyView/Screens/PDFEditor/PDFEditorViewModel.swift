//
//  PDFEditorViewModel.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import SwiftUI
import PDFKit

final class PDFEditorViewModel: ObservableObject {
	@Published var selectedImages: [UIImage] = []
	@Published var pdfDocument: PDFDocument?
	@Published var errorMessage: String?

	@Published var isSourceDialogPresented = false
	@Published var isImagePickerPresented = false
	@Published var isFilePickerPresented = false
	@Published var isPDFViewerPresented = false

	private let storage: PDFStorage

	init(storage: PDFStorage = CoreDataPDFStorage()) {
		self.storage = storage
	}

	func openSourceDialog() {
		isSourceDialogPresented = true
	}

	func selectGallerySource() {
		isImagePickerPresented = true
	}

	func selectFileSource() {
		isFilePickerPresented = true
	}

	func didTapGeneratePDF() {
		generatePDF()
		if pdfDocument != nil {
			isPDFViewerPresented = true
		}
	}

	func closePDFViewer() {
		isPDFViewerPresented = false
		clearSelection()
	}

	func clearSelection() {
		selectedImages.removeAll()
		pdfDocument = nil
	}

	func generatePDF() {
		guard !selectedImages.isEmpty else { return }

		let pdfPages = selectedImages.compactMap { PDFPage(image: $0) }

		guard !pdfPages.isEmpty else { return }

		let pdf = PDFDocument()
		for (index, page) in pdfPages.enumerated() {
			pdf.insert(page, at: index)
		}

		self.pdfDocument = pdf
	}

	@MainActor
	func savePDFDocument(named rawName: String) -> Bool {
		let name = rawName.trimmingCharacters(in: .whitespacesAndNewlines)

		guard !name.isEmpty else {
			errorMessage = "Введите название документа"
			return false
		}

		guard let pdfDocument = pdfDocument,
			  let pdfData = pdfDocument.dataRepresentation(),
			  let thumbnail = generateThumbnail() else {
			errorMessage = "Ошибка создания PDF документа"
			return false
		}

		do {
			_ = try storage.savePDFDocument(
				name: name,
				pdfData: pdfData,
				thumbnail: thumbnail
			)
			return true
		} catch {
			errorMessage = "Ошибка сохранения документа: \(error.localizedDescription)"
			return false
		}
	}

	private func generateThumbnail() -> UIImage? {
		guard let firstImage = selectedImages.first else { return nil }

		let targetSize = CGSize(width: 200, height: 280)
		let renderer = UIGraphicsImageRenderer(size: targetSize)

		return renderer.image { content in
			UIColor.white.set()
			content.fill(CGRect(origin: .zero, size: targetSize))

			let aspectRatio = firstImage.size.width / firstImage.size.height
			let targetRect: CGRect

			if aspectRatio > 1 {
				let height = targetSize.width / aspectRatio
				targetRect = CGRect(x: 0, y: (targetSize.height - height) / 2, width: targetSize.width, height: height)
			} else {
				let width = targetSize.height * aspectRatio
				targetRect = CGRect(x: (targetSize.width - width) / 2, y: 0, width: width, height: targetSize.height)
			}

			firstImage.draw(in: targetRect)
		}
	}
}
