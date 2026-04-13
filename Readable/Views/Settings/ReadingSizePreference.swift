//
//  ReadingSizePreference.swift
//  Readable
//
//  Created by Will on 02/04/2026.
//

import SwiftUI

enum ReadingSizePreference: String, CaseIterable, Identifiable {
    case system
    case large
    case extraLarge
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .system:
            return "System"
        case .large:
            return "Large"
        case .extraLarge:
            return "Extra Large"
        }
    }
}
