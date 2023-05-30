//
//  KeyboardModView.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/27/23.
//

import Foundation
import UIKit
import SwiftUI

struct KeyboardModView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
}

extension View {
    func dismissKeyboardMod() -> some View {
        self.modifier(KeyboardModView())
    }
}
