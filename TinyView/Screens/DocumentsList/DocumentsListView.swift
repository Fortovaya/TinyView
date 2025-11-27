//
//  DocumentsListView.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import SwiftUI
import PDFKit

struct DocumentsListView: View {
	@StateObject var viewModel: DocumentsListViewModel

	var body: some View {
		Group {
			if viewModel.documents.isEmpty {
				EmptyStateView(
					systemImageName: "doc.text",
					message: "У вас пока нет сохранённых документов",
					imageSize: 60
				)
				.foregroundColor(.gray)
				.padding(.horizontal, 24)
				.frame(maxWidth: .infinity, alignment: .center)
			} else {
				documentsList
			}
		}
		.navigationTitle("Мои PDF")
		.sheet(isPresented: $viewModel.showShareSheet) {
			if let document = viewModel.documentToShare {
				CustomShareSheet(activityItems: [document.fileURL])
			}
		}
		.sheet(isPresented: $viewModel.showMergeSelection) {
			MergeSelectionView(viewModel: viewModel)
		}
	}

	private var documentsList: some View {
		DocumentsListContent(viewModel: viewModel)
	}
}
