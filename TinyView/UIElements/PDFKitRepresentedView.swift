//
//  PDFKItRepresentedView.swift
//  TinyView
//
//  Created by Алина on 25.11.2025.
//

import SwiftUI
import PDFKit

struct PDFKitRepresentedView: UIViewRepresentable {

	@Binding var document: PDFDocument
	@Binding var currentPageIndex: Int

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func makeUIView(context: Context) -> PDFView {
		let pdfView = PDFView()
		pdfView.autoScales = true
		pdfView.displayMode = .singlePageContinuous
		pdfView.displayDirection = .vertical
		pdfView.document = document

		NotificationCenter.default.addObserver(
			context.coordinator,
			selector: #selector(Coordinator.handlePageChanged(_:)),
			name: Notification.Name.PDFViewPageChanged,
			object: pdfView
		)

		if let page = document.page(at: currentPageIndex) ?? document.page(at: 0) {
			pdfView.go(to: page)
		}

		return pdfView
	}

	func updateUIView(_ uiView: PDFView, context: Context) {
		if uiView.document !== document {
			uiView.document = document
		}

		if let page = document.page(at: currentPageIndex) {
			uiView.go(to: page)
		}
	}

	class Coordinator: NSObject {

		var parent: PDFKitRepresentedView

		init(_ parent: PDFKitRepresentedView) {
			self.parent = parent
		}

		@objc
		func handlePageChanged(_ notification: Notification) {
			guard
				let pdfView = notification.object as? PDFView,
				let document = pdfView.document,
				let currentPage = pdfView.currentPage
			else { return }

			let index = document.index(for: currentPage)

			DispatchQueue.main.async {
				self.parent.currentPageIndex = index
			}
		}

		deinit {
			NotificationCenter.default.removeObserver(self)
		}
	}
}
