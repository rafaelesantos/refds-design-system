import SwiftUI

public struct RefdsUI {
    public static let shared = RefdsUI()
    
    @State public var defaultFontFamily: RefdsFontFamily = .moderat
    
    public func setNavigationBarAppearance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.refds(size: .large, weight: .bold, family: defaultFontFamily).withSize(32)]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.refds(size: .normal, weight: .bold, family: defaultFontFamily).withSize(17)]
    }
}
