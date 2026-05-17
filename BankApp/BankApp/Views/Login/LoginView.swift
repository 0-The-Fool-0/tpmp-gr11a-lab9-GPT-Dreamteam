//
//  LoginView.swift
//  BankApp
//

import SwiftUI
import Combine

struct LoginView: View {
    @EnvironmentObject private var session: SessionStore
    @Environment(\.appDependencies) private var dependencies

    var body: some View {
        if let dependencies {
            LoginFormView(
                viewModel: LoginViewModel(
                    authService: dependencies.authService,
                    session: session
                )
            )
        } else {
            ProgressView()
        }
    }
}

private struct LoginFormView: View {
    @StateObject private var viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                BankLogoView()
                    .padding(.top, 8)

                VStack(alignment: .leading, spacing: 10) {
                    Text("login.eyebrow")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    Text("login.title")
                        .font(.largeTitle.bold())

                    Text("login.subtitle")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                VStack(spacing: 18) {
                    LabeledTextField(
                        label: "login.field.login",
                        placeholder: "login.placeholder.login",
                        text: $viewModel.login,
                        accessibilityIdentifier: AccessibilityID.loginField
                    )
                    LabeledTextField(
                        label: "login.field.password",
                        placeholder: "login.placeholder.password",
                        text: $viewModel.password,
                        isSecure: true,
                        accessibilityIdentifier: AccessibilityID.passwordField
                    )
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .accessibilityIdentifier(AccessibilityID.loginError)
                }

                Button(action: viewModel.signIn) {
                    Text("login.button.signIn")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.white)
                .background(Color.bankPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .accessibilityIdentifier(AccessibilityID.signInButton)

                Button(action: viewModel.faceIDTapped) {
                    Text("login.faceID")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 32)
        }
        .background(Color(.systemBackground))
        .alert("login.faceID.title", isPresented: $viewModel.showFaceIDAlert) {
            Button("common.ok", role: .cancel) {}
        } message: {
            Text("login.faceID.message")
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(SessionStore())
        .environment(\.appDependencies, AppDependencies(persistence: .preview))
}
