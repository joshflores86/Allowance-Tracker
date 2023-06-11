//
//  KeyboardModView.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/27/23.
//

import Foundation
import UIKit
import SwiftUI



extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for:  nil)
    }
}


