//
//  DocumentsListViewModel.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import SwiftUI
import Combine

final class DocumentsListViewModel: ObservableObject {
	@Published var documents: [StoredPDFModel] = []

	@Published var selectedForMerge: StoredPDFModel?
	@Published var showMergeSelection = false

	@Published var errorMessage: String?

	@Published var documentToShare: StoredPDFModel?
	@Published var showShareSheet = false


	private let storage: PDFStorage
	private var cancellables = Set<AnyCancellable>()

	init(storage: PDFStorage = CoreDataPDFStorage()) {
		self.storage = storage
		setupNotifications()

		Task { @MainActor in
			await loadDocuments()
		}
	}

	@MainActor
	func loadDocuments() async {
		do {
			documents = try storage.fetchAllDocuments()
		} catch {
			errorMessage = "Ошибка загрузки документов: \(error.localizedDescription)"
		}
	}

	@MainActor
	func deleteDocument(_ document: StoredPDFModel) {
		do {
			try storage.deleteDocument(document)
			Task { @MainActor in
				await loadDocuments()
			}
		} catch {
			errorMessage = "Ошибка удаления документа: \(error.localizedDescription)"
		}
	}

	func shareDocument(_ document: StoredPDFModel) {
		documentToShare = document
		showShareSheet = true
	}

	func prepareForMerge(_ document: StoredPDFModel) {
		selectedForMerge = document
		showMergeSelection = true
	}

	@MainActor
	func mergeWithSelected(_ secondDocument: StoredPDFModel) {
		guard let firstDocument = selectedForMerge else { return }

		do {
			_ = try storage.mergeDocuments(firstDocument, secondDocument)
			Task { @MainActor in
				await loadDocuments()
			}
		} catch {
			errorMessage = "Ошибка объединения документов: \(error.localizedDescription)"
		}

		selectedForMerge = nil
		showMergeSelection = false
	}

	func cancelMerge() {
		selectedForMerge = nil
		showMergeSelection = false
	}

	private func setupNotifications() {
		NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
			.sink { [weak self] _ in
				Task { @MainActor in
					await self?.loadDocuments()
				}
			}
			.store(in: &cancellables)
	}
}
