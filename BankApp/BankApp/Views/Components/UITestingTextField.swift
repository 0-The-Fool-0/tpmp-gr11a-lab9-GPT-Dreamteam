//
//  UITestingTextField.swift
//  BankApp
//

import SwiftUI
import UIKit

/// UIKit fields for UI tests: `.oneTimeCode` stops the system "Save Password" sheet.
struct UITestingTextField: UIViewRepresentable {
    @Binding var text: String
    var isSecure: Bool
    var accessibilityIdentifier: String?

    func makeUIView(context: Context) -> UITextField {
        let field = UITextField()
        field.delegate = context.coordinator
        field.isSecureTextEntry = isSecure
        field.accessibilityIdentifier = accessibilityIdentifier
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.textContentType = .oneTimeCode
        field.borderStyle = .none
        field.backgroundColor = .clear
        return field
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        uiView.isSecureTextEntry = isSecure
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    final class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }

        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            let current = textField.text ?? ""
            guard let textRange = Range(range, in: current) else { return true }
            let updated = current.replacingCharacters(in: textRange, with: string)
            text = updated
            return true
        }
    }
}
