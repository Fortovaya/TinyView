//
//  Font+Extansion.swift
//  TinyView
//
//  Created by Алина on 25.11.2025.
//

import SwiftUI

extension Font {

	enum Headline {
		static var medium: Font {
			Font.system(size: 17, weight: .medium)
		}

		static var semiBold: Font {
			Font.system(size: 16, weight: .semibold)
		}
	}

	enum LargeTitle {
		static var regular: Font {
			Font.system(size: 34, weight: .regular)
		}
	}

	enum Title2 {
		static var semiBold: Font {
			Font.system(size: 22, weight: .semibold)
		}
	}
}

