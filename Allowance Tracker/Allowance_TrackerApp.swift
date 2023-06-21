//
//  Allowance_TrackerApp.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/25/23.
//

import SwiftUI

@main
struct Allowance_TrackerApp: App {
    static var userInfo = UserModel(id: UUID(), name: "", amount: "", valueHolder: [], steps: 0)
    @EnvironmentObject var dataViewModel: DataViewModel
    var body: some Scene {
        WindowGroup {
            SplashScreen(dataViewModel: DataViewModel(usersInfo: UserModel(id: UUID(), name: "", amount: "", valueHolder: [], steps: 0)))
//            MainView(dataViewModel: DataViewModel(usersInfo: Allowance_TrackerApp.userInfo))
        }
    }
}
