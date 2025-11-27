//
//  DocumentContextMenu.swift
//  TinyView
//
//  Created by Алина on 27.11.2025.
//

import SwiftUI

struct DocumentContextMenu: View {
	@ObservedObject var viewModel: DocumentsListViewModel
	
	let document: StoredPDFModel
	
	var body: some View {
		Button {
			viewModel.shareDocument(document)
		} label: {
			Label("Поделиться", systemImage: "square.and.arrow.up")
		}
		
		Button(role: .destructive) {
			viewModel.deleteDocument(document)
		} label: {
			Label("Удалить", systemImage: "trash")
		}
		
		Button {
			viewModel.prepareForMerge(document)
		} label: {
			Label("Объединить", systemImage: "doc.on.doc")
		}
	}
}
