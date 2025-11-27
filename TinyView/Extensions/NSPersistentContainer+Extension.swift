//
//  NSPersistentContainer+Extension.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import CoreData

extension NSPersistentContainer {
	static let shared: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "PDFDocuments")
		container.loadPersistentStores { _, error in
			if let error = error {
				fatalError("Unable to load persistent stores: \(error)")
			}
		}
		return container
	}()
}
