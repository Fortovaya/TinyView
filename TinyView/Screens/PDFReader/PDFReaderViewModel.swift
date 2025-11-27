//
//  PDFReaderViewModel.swift
//  TinyView
//
//  Created by Алина on 27.11.2025.
//
import SwiftUI
import PDFKit

final class PDFReaderViewModel: ObservableObject {

	@Published var document: PDFDocument
	@Published var currentPageIndex: Int = 0
	@Published var isShareSheetPresented = false
	@Published var isActionsDialogPresented = false
	@Published var isNameSheetPresented = false
	@Published var documentName: String = ""

	init(document: PDFDocument) {
		self.document = document
	}


	var pageCounterText: String? {
		guard document.pageCount > 1 else { return nil }
		return "Страница \(currentPageIndex + 1) из \(document.pageCount)"
	}


	func showActions() {
		isActionsDialogPresented = true
	}

	func showShare() {
		isShareSheetPresented = true
	}

	func showNameSheet() {
		isNameSheetPresented = true
	}

	func cancelNameSheet() {
		isNameSheetPresented = false
		documentName = ""
	}

	func confirmName(onSave: (String) -> Void) {
		let trimmed = documentName
			.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !trimmed.isEmpty else { return }

		isNameSheetPresented = false
		onSave(trimmed)
	}

	func deleteCurrentPage(onDocumentEmpty: () -> Void) {
		guard document.pageCount > 0 else { return }

		let index = max(0, min(currentPageIndex, document.pageCount - 1))
		document.removePage(at: index)

		if document.pageCount == 0 {
			onDocumentEmpty()
		} else {
			currentPageIndex = min(currentPageIndex, document.pageCount - 1)
		}
	}
}
