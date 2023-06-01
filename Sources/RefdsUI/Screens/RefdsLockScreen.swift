import SwiftUI
import RefdsResource
import RefdsCore

public struct RefdsLockScreen: View {
    @StateObject private var authenticator = RefdsAuth()
    @State private var alert: RefdsAlert.ViewData?
    @Binding private var authenticated: Bool
    private var automaticRequest: Bool
    
    public init(authenticated: Binding<Bool>, automaticRequest: Bool = true) {
        self._authenticated = authenticated
        self.automaticRequest = automaticRequest
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
                authIcon.padding()
                RefdsText(.refdsString(.lockScreen(.title)), style: .title2, weight: .bold)
                RefdsText(.refdsString(.lockScreen(.description)), alignment: .center)
            Spacer()
            RefdsButton(.refdsString(.lockScreen(.buttonTitle)), color: .accentColor, style: .primary, maxSize: true) {
                authenticate()
            }
            .disabled(authenticator.isLoading)
            .padding()
        }
        .frame(maxWidth: 450)
        .padding()
        .refdsAlert(viewData: $alert)
        .onAppear {
            if automaticRequest { authenticate() }
        }
    }
    
    private var alertError: RefdsAlert.ViewData {
        .init(style: .inline(.critical, "Parece que encontramos um pequeno obstáculo ao tentar autenticar você"))
    }
    
    private var authIcon: some View {
        RefdsIcon(symbol: .lockShieldFill, color: .accentColor, size: 60, renderingMode: .hierarchical)
            .refdsParallax(magnitude: 5)
            .refdsCard()
            .refdsParallax(magnitude: 10)
    }
    
    private func authenticate() {
        authenticator.authenticate { authenticated = true } onError: { alert = alertError }
    }
}

struct RefdsLockScreenView: View {
    @State private var authenticated: Bool = false
    var body: some View {
        RefdsLockScreen(authenticated: $authenticated)
    }
}

struct RefdsLockScreen_Previews: PreviewProvider {
    static var previews: some View {
        RefdsLockScreenView()
    }
}
