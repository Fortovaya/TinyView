//
//  CoreDataPDFStorage.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import UIKit
import PDFKit
import CoreData

final class CoreDataPDFStorage: PDFStorage {

	private let persistentContainer: NSPersistentContainer
	private let fileManager: FileManager

	init(persistentContainer: NSPersistentContainer = .shared) {
		self.persistentContainer = persistentContainer
		self.fileManager = FileManager.default
	}

	// MARK: - PDFStorage Protocol
	func savePDFDocument(name: String, pdfData: Data, thumbnail: UIImage) throws -> StoredPDFModel {
		guard let thumbnailData = thumbnail.jpegData(compressionQuality: 0.7) else {
			throw PDFStorageError.invalidThumbnail
		}

		let context = persistentContainer.viewContext
		let entity = PDFDocumentEntity(context: context)
		entity.id = UUID()
		entity.name = name
		entity.fileExtension = "pdf"
		entity.createdAt = Date()
		entity.thumbnailData = thumbnailData

		let fileName = "\(entity.id.uuidString).pdf"
		let fileURL = try savePDFDataToFileSystem(pdfData, fileName: fileName)
		entity.fileURL = fileName

		try context.save()

		return StoredPDFModel(
			id: entity.id,
			name: entity.name,
			fileExtension: entity.fileExtension,
			createdAt: entity.createdAt,
			thumbnail: thumbnail,
			fileURL: fileURL
		)
	}

	func fetchAllDocuments() throws -> [StoredPDFModel] {
		let context = persistentContainer.viewContext
		let request: NSFetchRequest<PDFDocumentEntity> = PDFDocumentEntity.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

		let entities = try context.fetch(request)
		return try entities.map { entity in
			guard let fileURL = getDocumentURL(for: entity.id),
				  fileManager.fileExists(atPath: fileURL.path) else {
				throw PDFStorageError.fileSystemError
			}

			let thumbnail: UIImage?
			if let thumbnailData = entity.thumbnailData {
				thumbnail = UIImage(data: thumbnailData)
			} else {
				thumbnail = nil
			}

			return StoredPDFModel(
				id: entity.id,
				name: entity.name,
				fileExtension: entity.fileExtension,
				createdAt: entity.createdAt,
				thumbnail: thumbnail,
				fileURL: fileURL
			)
		}
	}

	func deleteDocument(_ document: StoredPDFModel) throws {
		let context = persistentContainer.viewContext
		let request: NSFetchRequest<PDFDocumentEntity> = PDFDocumentEntity.fetchRequest()
		request.predicate = NSPredicate(format: "id == %@", document.id as CVarArg)

		guard let entity = try context.fetch(request).first else {
			throw PDFStorageError.documentNotFound
		}

		let path = document.fileURL.path
		if fileManager.fileExists(atPath: path) {
			do {
				try fileManager.removeItem(at: document.fileURL)
			} catch {
				
			}
		}

		context.delete(entity)
		try context.save()
	}

	func mergeDocuments(_ first: StoredPDFModel, _ second: StoredPDFModel) throws -> StoredPDFModel {
		guard let firstPDF = PDFDocument(url: first.fileURL),
			  let secondPDF = PDFDocument(url: second.fileURL) else {
			throw PDFStorageError.mergeFailed
		}

		let mergedPDF = PDFDocument()
		var pageIndex = 0

		for i in 0..<firstPDF.pageCount {
			if let page = firstPDF.page(at: i) {
				mergedPDF.insert(page, at: pageIndex)
				pageIndex += 1
			}
		}

		for i in 0..<secondPDF.pageCount {
			if let page = secondPDF.page(at: i) {
				mergedPDF.insert(page, at: pageIndex)
				pageIndex += 1
			}
		}

		guard let mergedData = mergedPDF.dataRepresentation(),
			  let thumbnail = generateThumbnail(for: mergedPDF) else {
			throw PDFStorageError.mergeFailed
		}

		let name = "Объединенный_\(first.name)_\(second.name)"
		return try savePDFDocument(name: name, pdfData: mergedData, thumbnail: thumbnail)
	}

	func getDocumentURL(for id: UUID) -> URL? {
		let fileName = "\(id.uuidString).pdf"
		return getDocumentsDirectory()?.appendingPathComponent(fileName)
	}

	func documentExists(with id: UUID) -> Bool {
		guard let url = getDocumentURL(for: id) else { return false }
		return fileManager.fileExists(atPath: url.path)
	}

	private func savePDFDataToFileSystem(_ data: Data, fileName: String) throws -> URL {
		guard let documentsDirectory = getDocumentsDirectory() else {
			throw PDFStorageError.fileSystemError
		}

		let fileURL = documentsDirectory.appendingPathComponent(fileName)
		try data.write(to: fileURL)
		return fileURL
	}

	private func getDocumentsDirectory() -> URL? {
		return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
	}

	private func generateThumbnail(for document: PDFDocument) -> UIImage? {
		guard let page = document.page(at: 0) else { return nil }

		_ = page.bounds(for: .mediaBox)
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 200, height: 280))

		return renderer.image { ctx in
			UIColor.white.set()
			ctx.fill(CGRect(origin: .zero, size: renderer.format.bounds.size))

			ctx.cgContext.translateBy(x: 0.0, y: renderer.format.bounds.size.height)
			ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

			page.draw(with: .mediaBox, to: ctx.cgContext)
		}
	}
}
