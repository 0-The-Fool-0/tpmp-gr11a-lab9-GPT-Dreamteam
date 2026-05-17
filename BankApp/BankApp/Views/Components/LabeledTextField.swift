//
//  LabeledTextField.swift
//  BankApp
//

import SwiftUI
import Combine

struct LabeledTextField: View {
    let label: LocalizedStringKey
    let placeholder: LocalizedStringKey
    @Binding var text: String
    var isSecure = false
    var accessibilityIdentifier: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Group {
                if AppDependencies.isUITesting {
                    UITestingTextField(
                        text: $text,
                        isSecure: isSecure,
                        accessibilityIdentifier: accessibilityIdentifier
                    )
                } else if isSecure {
                    SecureField(placeholder, text: $text)
                        .textContentType(.password)
                } else {
                    TextField(placeholder, text: $text)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textContentType(.username)
                }
            }
            .accessibilityIdentifier(accessibilityIdentifier ?? "")
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.bankFieldBorder, lineWidth: 1)
            )
        }
    }
}
