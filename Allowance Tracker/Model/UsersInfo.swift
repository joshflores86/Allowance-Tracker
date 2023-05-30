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


struct UsersInfo: Hashable, Identifiable ,Codable {
    
    let id: UUID
    var name: String
    var amount: String
    var avatarImageData: Data?
    var initialValue: [String] = []
    var valueHolder: [String] = []
    var steps: Int
    var currency: String = ""
    
    var avatarImage: UIImage? {
        get{
            guard let imageData = avatarImageData else {
                return nil
            }
            return UIImage(data: imageData)!
        }set{
            avatarImageData = newValue?.pngData()
        }
    }
    
    
}
