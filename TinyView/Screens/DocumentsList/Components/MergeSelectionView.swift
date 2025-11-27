//
//  MergeSelectionView.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import SwiftUI

struct MergeSelectionView: View {
	@ObservedObject var viewModel: DocumentsListViewModel
	@Environment(\.dismiss) private var dismiss

	var availableDocuments: [StoredPDFModel] {
		viewModel.documents.filter { $0.id != viewModel.selectedForMerge?.id }
	}

	var body: some View {
		NavigationView {
			Group {
				if availableDocuments.isEmpty {
					Text("Нет других документов для объединения")
						.foregroundColor(.gray)
				} else {
					List(availableDocuments) { document in
						Button {
							viewModel.mergeWithSelected(document)
							dismiss()
						} label: {
							DocumentCell(document: document)
						}
						.buttonStyle(.plain)
					}
				}
			}
			.navigationTitle("Выберите документ")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Отмена") {
						viewModel.cancelMerge()
						dismiss()
					}
				}
			}
		}
	}
}
