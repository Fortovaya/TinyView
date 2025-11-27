//
//  PDFReaderView.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import SwiftUI
import PDFKit

struct PDFReaderView: View {

	@Environment(\.dismiss) private var dismiss
	@StateObject private var viewModel: PDFReaderViewModel

	let onSave: ((String) -> Void)?

	init(document: PDFDocument,onSave: ((String) -> Void)? = nil) {
		_viewModel = StateObject(wrappedValue: PDFReaderViewModel(document: document))
		self.onSave = onSave
	}

	var body: some View {
		NavigationView {
			ZStack(alignment: .top) {
				PDFKitRepresentedView(
					document: $viewModel.document,
					currentPageIndex: $viewModel.currentPageIndex
				)
				.ignoresSafeArea()

				if let counterText = viewModel.pageCounterText {
					Text(counterText)
						.padding(.horizontal, 12)
						.padding(.vertical, 8)
						.background(.ultraThinMaterial)
						.cornerRadius(12)
						.padding(.top, 12)
				}
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						dismiss()
					} label: {
						Image(systemName: "arrowshape.turn.up.backward")
					}
				}

				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						viewModel.showActions()
					} label: {
						Image(systemName: "line.3.horizontal")
					}
				}
			}
		}
		.navigationBarBackButtonHidden(true)
		.sheet(isPresented: $viewModel.isShareSheetPresented) {
			if let data = viewModel.document.dataRepresentation() {
				CustomShareSheet(activityItems: [data])
			}
		}
		.sheet(isPresented: $viewModel.isNameSheetPresented) {
			nameSheet
		}
		.confirmationDialog(
			"Действия с документом",
			isPresented: $viewModel.isActionsDialogPresented,
			titleVisibility: .visible
		) {
			Button("Удалить страницу", role: .destructive) {
				viewModel.deleteCurrentPage {
					dismiss()
				}
			}

			if onSave != nil {
				Button("Сохранить документ") {
					viewModel.showNameSheet()
				}
			}

			Button("Поделиться") {
				viewModel.showShare()
			}

			Button("Отмена", role: .cancel) { }
		}
	}

	private var nameSheet: some View {
		VStack(spacing: 20) {
			TextField("Название файла", text: $viewModel.documentName)
				.textFieldStyle(.roundedBorder)
				.padding()

			Button("Сохранить") {
				guard let onSave else { return }
				viewModel.confirmName(onSave: onSave)
			}

			Button("Отмена") {
				viewModel.cancelNameSheet()
			}
		}
		.padding()
	}
}
