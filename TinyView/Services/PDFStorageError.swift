//
//  PDFStorageError.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import SwiftUI

enum PDFStorageError: Error {
	case invalidData
	case fileSystemError
	case documentNotFound
	case mergeFailed
	case invalidThumbnail
}
