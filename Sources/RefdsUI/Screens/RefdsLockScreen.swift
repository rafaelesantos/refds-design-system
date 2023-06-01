import SwiftUI
import RefdsResource
import RefdsCore

public struct RefdsLockScreen: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var authenticator = RefdsAuth()
    @State private var alert: RefdsAlert.ViewData?
    @Binding private var authenticated: Bool
    @State private var automaticRequest: Bool
    
    public init(authenticated: Binding<Bool>, automaticRequest: Bool = true) {
        self._authenticated = authenticated
        self._automaticRequest = State(initialValue: automaticRequest)
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
        .onChange(of: scenePhase, perform: { newValue in
            switch newValue {
            case .active:
                if automaticRequest {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        authenticate()
                    }
                }
            default: break
            }
        })
    }
    
    private var alertError: RefdsAlert.ViewData {
        .init(style: .inline(.critical, .refdsString(.lockScreen(.alertAuthError))))
    }
    
    private var authIcon: some View {
        RefdsIcon(symbol: .lockShieldFill, color: .accentColor, size: 60, renderingMode: .hierarchical)
            .refdsParallax(magnitude: 7)
            .refdsCard()
            .refdsParallax(magnitude: 14)
    }
    
    private func authenticate() {
        authenticator.authenticate { authenticated = true } onError: {
            alert = alertError
            automaticRequest = false
        }
    }
}

struct RefdsLockScreenModifier: ViewModifier {
    @AppStorage(.refdsString(.storage(.auth))) private var allowAuth: Bool = false
    @Binding var authenticated: Bool
    var automaticRequest: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                ZStack {
                    if !authenticated, allowAuth {
                        RefdsLockScreen(authenticated: $authenticated, automaticRequest: automaticRequest)
                            .background()
                    }
                }.animation(.spring(), value: authenticated)
            }
    }
}

public extension View {
    func refdsAuth(autheticated: Binding<Bool>, automaticRequest: Bool = true) -> some View {
        self.modifier(RefdsLockScreenModifier(authenticated: autheticated, automaticRequest: automaticRequest))
    }
}

struct RefdsLockScreenView: View {
    @State private var authenticated: Bool = false
    var body: some View {
        RefdsAlert(style: .basic(.critical, "Lorem Ipsum", nil))
            .refdsAuth(autheticated: $authenticated)
    }
}

struct RefdsLockScreen_Previews: PreviewProvider {
    static var previews: some View {
        RefdsLockScreenView()
    }
}
