//
//  RootTabView.swift
//  Readable
//
//  Created by Will on 26/03/2026.
//

import SwiftUI
import SwiftData

/// Tab Bar Root View
struct RootTabView: View {
    var body: some View {
        NotesListView()
    }
}

#Preview {
    RootTabView()
        .modelContainer(previewContainer)
}
