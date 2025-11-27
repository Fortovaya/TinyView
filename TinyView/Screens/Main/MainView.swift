//
//  MainView.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import SwiftUI

struct MainView: View {
	@StateObject private var editorViewModel = PDFEditorViewModel()
	@StateObject private var documentsViewModel = DocumentsListViewModel()

	var body: some View {
			TabView {
				PDFEditorView(viewModel: editorViewModel)
					.tabItem {
						Label("Создать", systemImage: "plus.square.on.square")
					}

				DocumentsListView(viewModel: documentsViewModel)
					.tabItem {
						Label("Документы", systemImage: "doc.richtext")
					}
			}
	}
}
