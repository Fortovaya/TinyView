//
//  PDFEditorView.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import SwiftUI

struct PDFEditorView: View {

	@StateObject var viewModel: PDFEditorViewModel

	var body: some View {
		content
			.padding()
			.confirmationDialog(
				"Выберите источник",
				isPresented: $viewModel.isSourceDialogPresented,
				titleVisibility: .visible
			) {
				Button("Из галереи") {
					viewModel.selectGallerySource()
				}
				Button("Из хранилища") {
					viewModel.selectFileSource()
				}
				Button("Отмена", role: .cancel) { }
			}
			.sheet(isPresented: $viewModel.isImagePickerPresented) {
				ImagePicker(images: $viewModel.selectedImages)
			}
			.sheet(isPresented: $viewModel.isFilePickerPresented) {
				FileImagePicker(images: $viewModel.selectedImages)
			}
			.fullScreenCover(isPresented: $viewModel.isPDFViewerPresented) {
				if let document = viewModel.pdfDocument {
					PDFReaderView(document: document, onSave: { name in
						let isSaved = viewModel.savePDFDocument(named: name)
						if isSaved {
							viewModel.closePDFViewer()
						}
					})
				}
			}
	}

	var content: some View {
		VStack(spacing: 16) {
			Text("Создать PDF")
				.font(.largeTitle.bold())
				.multilineTextAlignment(.center)
				.frame(maxWidth: .infinity)
				.padding(.top, 20)
			VStack {
				Spacer(minLength: 0)
				imagesSection
				Spacer(minLength: 0)
			}
			.frame(maxHeight: .infinity)
			actionsSection
				.padding(.bottom, 20)
		}
	}

	var imagesSection: some View {
		Group {
			if viewModel.selectedImages.isEmpty {
				EmptyStateView(
					systemImageName: "photo.on.rectangle",
					message: "Добавьте фотографии из галереи или хранилища, чтобы создать PDF-документ",
					imageSize: 100
				)
				.padding(.horizontal, 24)
			} else {
				imagesScrollView
			}
		}
	}

	var imagesScrollView: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 12) {
				ForEach(Array(viewModel.selectedImages.enumerated()), id: \.offset) { _, image in
					Image(uiImage: image)
						.resizable()
						.scaledToFill()
						.frame(width: 100, height: 140)
						.clipShape(RoundedRectangle(cornerRadius: 12))
				}
			}
			.padding(.horizontal, 16)
		}
	}

	var actionsSection: some View {
		VStack(spacing: 12) {
			BaseButton(title: "Выбрать файл") {
				viewModel.openSourceDialog()
			}
			BaseButton(
				isActive: !viewModel.selectedImages.isEmpty,
				title: "Сгенерировать PDF"
			) {
				viewModel.didTapGeneratePDF()
			}
		}
	}
}
