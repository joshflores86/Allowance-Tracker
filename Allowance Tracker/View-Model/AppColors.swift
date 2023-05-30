//
//  AppColors.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/28/23.
//

import Foundation
import SwiftUI

struct AppColors {
    
    
    
        static let appColorGray = Color(#colorLiteral(red: 0.5568627715, green: 0.5568627715, blue: 0.5568627715, alpha: 1))
        static let appColorBlue = Color(#colorLiteral(red: 0.3052682579, green: 0.6510350108, blue: 0.962226212, alpha: 1))
        static let appColorYellow = Color(#colorLiteral(red: 0.9929426312, green: 0.7593198419, blue: 0.263358742, alpha: 1))
        
        
    }

    extension Color: RawRepresentable {
      public init?(rawValue: String) {
        do {
          let encodedData = rawValue.data(using: .utf8)!
          let components = try JSONDecoder().decode([Double].self, from: encodedData)
          self = Color(red: components[0],
                       green: components[1],
                       blue: components[2],
                       opacity: components[3])
        }
        catch {
          return nil
        }
      }
     
      public var rawValue: String {
        guard let cgFloatComponents = UIColor(self).cgColor.components else { return "" }
        let doubleComponents = cgFloatComponents.map { Double($0) }
        do {
          let encodedComponents = try JSONEncoder().encode(doubleComponents)
          return String(data: encodedComponents, encoding: .utf8) ?? ""
        }
        catch {
          return ""
        }
      }
    }

    







