//
//  PDFStorage.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import UIKit
import PDFKit

protocol PDFStorage {
	func savePDFDocument(name: String, pdfData: Data, thumbnail: UIImage) throws -> StoredPDFModel
	func fetchAllDocuments() throws -> [StoredPDFModel]
	func deleteDocument(_ document: StoredPDFModel) throws
	func mergeDocuments(_ first: StoredPDFModel, _ second: StoredPDFModel) throws -> StoredPDFModel
	func getDocumentURL(for id: UUID) -> URL?
	func documentExists(with id: UUID) -> Bool
}
