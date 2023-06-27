//
//  UsersInfo.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/25/23.
//

import Foundation
import UIKit
import SwiftUI
import CoreData


struct UserModel: Hashable, Identifiable ,Codable {
    
    
    
    let id: UUID
    var name: String
    var amount: String
    var avatarImageData: Data?
    var initialValue: [String] = []
    var secondValue: [String] = []
    var valueHolder: [String] 
    var steps: Int = 0
    var currency: String = ""
    
    var showNoButton: Bool = false
    var avatarImage: UIImage {
        get{
            guard let imageData = avatarImageData else {
                return UIImage(named: "default-avatar")!
            }
            return UIImage(data: imageData)!
        }set{
            avatarImageData = newValue.pngData()
        }
    }
}

struct BottomBarColorModifier: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .accentColor(color)
    }
}


