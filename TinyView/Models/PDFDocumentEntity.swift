//
//  PDFDocumentEntity.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import CoreData
import UIKit

@objc(PDFDocumentEntity)
public class PDFDocumentEntity: NSManagedObject {
	@NSManaged public var id: UUID
	@NSManaged public var name: String
	@NSManaged public var fileExtension: String
	@NSManaged public var createdAt: Date
	@NSManaged public var thumbnailData: Data?
	@NSManaged public var fileURL: String

	@nonobjc public class func fetchRequest() -> NSFetchRequest<PDFDocumentEntity> {
		return NSFetchRequest<PDFDocumentEntity>(entityName: "PDFDocumentEntity")
	}
}
