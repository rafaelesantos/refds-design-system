//
//  ApplicationExtension.swift
//  
//
//  Created by Rafael Santos on 21/12/22.
//

import Foundation
import SwiftUI

#if os(iOS)
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
