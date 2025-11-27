//
//  ImageCompression.swift
//  TinyView
//
//  Created by Алина on 26.11.2025.
//

import UIKit

final class ImageCompression {

	static let shared = ImageCompression()
	private init() {}

	private static let compressionQueue = DispatchQueue(
		label: "image-compression.queue",
		qos: .userInitiated
	)

	func compressIfNeeded(_ image: UIImage, maxMB: Double = 20.0) async -> UIImage {
		await withCheckedContinuation { continuation in
			ImageCompression.compressionQueue.async {
				let result = ImageCompression.syncCompressIfNeeded(image, maxMB: maxMB)
				continuation.resume(returning: result)
			}
		}
	}

	private static func syncCompressIfNeeded(_ image: UIImage, maxMB: Double) -> UIImage {
		let maxBytes = Int(maxMB * 1024 * 1024)

		guard let data = image.jpegData(compressionQuality: 1.0),
			  data.count > maxBytes else {
			return image
		}

		return binarySearchCompression(image: image, maxBytes: maxBytes)
	}

	private static func binarySearchCompression(image: UIImage, maxBytes: Int) -> UIImage {
		var low: CGFloat = 0.1
		var high: CGFloat = 0.9
		var bestData = image.jpegData(compressionQuality: low) ?? Data()

		while high - low > 0.05 {
			let mid = (low + high) / 2
			guard let midData = image.jpegData(compressionQuality: mid) else { break }

			if midData.count <= maxBytes {
				bestData = midData
				low = mid
			} else {
				high = mid
			}
		}

		return UIImage(data: bestData) ?? image
	}
}
