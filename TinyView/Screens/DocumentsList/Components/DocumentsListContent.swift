//
//  DocumentsListContent.swift
//  TinyView
//
//  Created by Алина on 27.11.2025.
//

import SwiftUI
import PDFKit

struct DocumentsListContent: View {
	@ObservedObject var viewModel: DocumentsListViewModel

	var body: some View {
		List {
			ForEach(viewModel.documents) { document in
				NavigationLink(destination: {
					if let pdfDocument = PDFDocument(url: document.fileURL) {
						PDFReaderView(document: pdfDocument)
					}
				}) {
					DocumentCell(document: document)
						.contentShape(Rectangle())
						.contextMenu {
							DocumentContextMenu(
								viewModel: viewModel,
								document: document
							)
						}
				}
			}
		}
	}
}
