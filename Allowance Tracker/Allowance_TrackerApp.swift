//
//  Allowance_TrackerApp.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/25/23.
//

import SwiftUI

@main
struct Allowance_TrackerApp: App {
    static var userInfo = UsersInfo(id: UUID(), name: "", amount: "", steps: 0)
    
    var body: some Scene {
        WindowGroup {
            SplashScreen(dataViewModel: DataViewModel(usersInfo: UsersInfo(id: UUID(), name: "", amount: "", steps: 0)))
//            MainView(dataViewModel: DataViewModel(usersInfo: Allowance_TrackerApp.userInfo))
        }
    }
}
