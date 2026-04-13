//
//  SettingsView.swift
//  Readable
//
//  Created by Will on 02/04/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    @AppStorage("readingSize") private var readingSizeRawValue: String = ReadingSizePreference.system.rawValue
    @AppStorage("comfortableSpacing") private var comfortableSpacing: Bool = false
    @AppStorage("increasedContrast") private var increasedContrast: Bool = false
    @AppStorage("reducedVisualNoise") private var reducedVisualNoise: Bool = false
    
    private var readingSize: Binding<ReadingSizePreference> {
        Binding(
            get: {
                ReadingSizePreference(rawValue: readingSizeRawValue) ?? .system
            },
            set: { newValue in
                readingSizeRawValue = newValue.rawValue
            }
        )
    }
    
    var body: some View {
        NavigationStack
        {
            Form {
                Section {
                    Picker("Reading Size", selection: readingSize) {
                        ForEach(ReadingSizePreference.allCases) { size in
                            Text(size.title).tag(size)
                        }
                    }
                } header: {
                    Text("Reading Size")
                } footer: {
                    Text("Adjust the text size used when reading and editing notes.")
                }
                
                Section("Reading Comfort") {
                    Toggle("Comfortable Spacing", isOn: $comfortableSpacing)
                    Toggle("Increased Contrast", isOn: $increasedContrast)
                    Toggle("Reduced Visual Noise", isOn: $reducedVisualNoise)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
