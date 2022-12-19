import SwiftUI

public class RefdsUI {
    public static let shared = RefdsUI()
    
    public var defaultFontFamily: FontFamily = .moderat
    
    #if os(iOS)
    public func setNavigationBarAppearance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.refds(size: .large, weight: .bold, family: .defaultConfiguration).withSize(32)]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.refds(size: .normal, weight: .bold, family: .defaultConfiguration).withSize(17)]
    }
    #endif
}
